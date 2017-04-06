//
//  SNRSeriesViewController.m
//  sonarr-ios
//
//  Created by Harry Singh on 20/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRNavigationViewController.h"
#import "SNRSeriesViewController.h"
#import "SNRSeriesTableViewCell.h"
#import "SNRBaseTableView.h"
#import "SNRServerManager.h"
#import "SNRServer.h"
#import "SNRSearchSeriesSheetViewController.h"
#import <MZFormSheetPresentationController/MZFormSheetPresentationViewController.h>

@interface SNRSeriesViewController () <SNRNavigationBarButtonProtocol, UIScrollViewDelegate, SNRServerManagerProtocol>
@property (weak, nonatomic) IBOutlet SNRBaseTableView *tableView;
@property (strong, nonatomic) SNRServer *server;
@end

@implementation SNRSeriesViewController

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.server = [SNRServerManager manager].activeServer;
    
    if(!self.server.series){
        __weak typeof(self) wself = self;
        [self.server seriesWithRefresh:NO andCompletion:^(NSArray<SNRSeries *> *series, NSError *error) {
            [wself.tableView.refreshControl endRefreshing];
            [wself.tableView reloadData];
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView.refreshControl addTarget:self action:@selector(didRequestPullToRefresh:) forControlEvents:UIControlEventValueChanged];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    if(!self.server.series.count){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.refreshControl beginRefreshing];
        });
    }
}

#pragma mark - TableView

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.server.series.count){
        return 50;
    }
    
    return ((1080.0f / 1920.0f) * MIN(CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame))) * 0.7f;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.server.series.count ? : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.server.series.count){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noSeriesCell" forIndexPath:indexPath];
        return cell;
    }
    
    SNRSeriesTableViewCell *seriesCell = [tableView dequeueReusableCellWithIdentifier:@"seriesCell" forIndexPath:indexPath];
    seriesCell.tag = indexPath.row;
    [seriesCell setSeries:[self.server.series objectAtIndex:indexPath.row] forServer:self.server];
    [seriesCell scrollViewDidScroll:self.tableView];
    return seriesCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    SNRSeriesTableViewCell *seriesCell = [tableView cellForRowAtIndexPath:indexPath];
    [seriesCell setSelected:YES];
    return;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.server.series.count){
        for (SNRSeriesTableViewCell *seriesCell in self.tableView.visibleCells) {
            if(![seriesCell respondsToSelector:@selector(scrollViewDidScroll:)]){
                continue;
            }
            
            [seriesCell scrollViewDidScroll:scrollView];
        }
    }
}

#pragma mark - Pull to refresh

-(void)didRequestPullToRefresh:(id)sender{
    __weak typeof(self) wself = self;
    [self.server validateServerWithCompletion:^(SNRStatus * _Nullable status, NSError * _Nullable error) {
        if(status){
            [self.server seriesWithRefresh:YES andCompletion:^(NSArray<SNRSeries *> *series, NSError *error) {
                if(series){
                    [wself.tableView reloadData];
                }
                //handle error
                [wself.tableView.refreshControl endRefreshing];
            }];
        }
    }];
}

#pragma mark - Navigation Protocol

-(void)addSeriesButtonTouchUpInside{
    [self presentViewController:[SNRSearchSeriesSheetViewController viewController] animated:YES completion:nil];
}

-(UIBarButtonItem *)rightBarButton{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                         target:self
                                                         action:@selector(addSeriesButtonTouchUpInside)];
}

#pragma mark - ServerManager Protocol

-(void)didSetActiveServer:(SNRServer *)server atIndex:(NSInteger)index{
    if(self.server == server){
        return;
    }
    
    self.server = server;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)didUnsetActiveServer:(SNRServer *)server atIndex:(NSInteger)integer{
    if([SNRServerManager manager].servers.count){
        return;
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)didAddSeries:(SNRSeries *)series atIndex:(NSInteger)index forServer:(SNRServer *)server{
    if(self.server != server){
        return;
    }
    
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

-(void)didRemoveSeries:(SNRSeries *)series atIndex:(NSInteger)index forServer:(SNRServer *)server{
    if(self.server != server){
        return;
    }
    
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
