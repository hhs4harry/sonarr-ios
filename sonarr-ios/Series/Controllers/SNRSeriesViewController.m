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
#import "SNRSeries.h"
#import "UIColor+App.h"
#import "SNRActivityIndicatorView.h"
#import "SNRRefreshControl.h"
#import "SNRSeasonsViewController.h"
#import "SNRSettingsViewController.h"
#import "SNRConstants.h"
#import "UIImage+Utility.h"

const CGFloat kNoSeriesHeight = 50.0f;
const CGFloat kSeriesHeightPercentage = 0.6f;

typedef enum : NSUInteger {
    SeriesTableViewCellTypeNone = 0,
    SeriesTableViewCellTypeSeries
} SeriesTableViewCellType;

@interface SNRSeriesViewController () <SNRNavigationBarButtonProtocol, UIScrollViewDelegate, SNRServerManagerProtocol, SNRBaseTableViewProtocol>
@property (weak, nonatomic) IBOutlet SNRBaseTableView *tableView;
@property (assign, nonatomic) SeriesTableViewCellType cellType;
@property (strong, nonatomic) SNRServer *server;
@end

@implementation SNRSeriesViewController

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.cellType = SeriesTableViewCellTypeNone;
    self.server = [SNRServerManager manager].activeServer;
}

#pragma mark - TableView

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.server.series.count){
        return kNoSeriesHeight;
    }
    
    UIImage *img = [((SNRSeries *)self.server.series.firstObject) imageWithType:ImageTypeFanArt].image;
    CGFloat ratio = kBannerSizeRatio;
    if (img) {
        ratio = img.ratio;
    }
    
    return (ratio * MIN(CGRectGetHeight(self.tableView.frame), CGRectGetWidth(self.tableView.frame))) * kSeriesHeightPercentage;
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
    if (![self.server.series objectAtIndex:indexPath.row]) {
        return;
    }
    
    SNRSeasonsViewController *seasonsVC = (id)[SNRSeasonsViewController viewController];
    seasonsVC.series = [self.server.series objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:seasonsVC animated:YES];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath{
    return; //Needed for ios 8.0 to work.
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *deleteString = [NSString stringWithFormat:@"Delete \"%@?\"", ((SNRSeries *)[self.server.series objectAtIndex:indexPath.row]).title];
    NSString *deleteMessage = [NSString stringWithFormat:@"Are you sure you want to delete \"%@\"?", ((SNRSeries *)[self.server.series objectAtIndex:indexPath.row]).title];
    
    __weak typeof(self) wself = self;
    __block UITableView *tView = tableView;
    
    UITableViewRowAction *rowAction= [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:deleteString message:deleteMessage preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [tView setEditing:NO animated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [tView setEditing:NO animated:YES];

            if([tView.indexPathsForVisibleRows containsObject:indexPath]){
                [SNRActivityIndicatorView showOnTint:YES onView:[tView cellForRowAtIndexPath:indexPath].contentView];
            }
            
            [wself.server deleteSeries:[wself.server.series objectAtIndex:indexPath.row] withFiles:NO andCompletion:^(BOOL success, NSError * _Nullable error) {
                if(!success){
                    [SNRActivityIndicatorView showOnTint:NO onView:[tView cellForRowAtIndexPath:indexPath].contentView];
                }
            }];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Delete + Files" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [tView setEditing:NO animated:YES];
            
            if([tView.indexPathsForVisibleRows containsObject:indexPath]){
                [SNRActivityIndicatorView showOnTint:YES onView:[tView cellForRowAtIndexPath:indexPath].contentView];
            }
            
            [wself.server deleteSeries:[wself.server.series objectAtIndex:indexPath.row] withFiles:YES andCompletion:^(BOOL success, NSError * _Nullable error) {
                if(!success){
                    [SNRActivityIndicatorView showOnTint:NO onView:[tView cellForRowAtIndexPath:indexPath].contentView];
                }
            }];
        }]];
        
        [wself presentViewController:alert animated:YES completion:nil];
    }];
    
    return @[rowAction];
}

#pragma mark - Pull to refresh

-(void)didRequestRefresh:(SNRBaseTableView *)tableView{
    __weak typeof(self) wself = self;
    [self.server validateServerWithCompletion:^(SNRStatus * _Nullable status, NSError * _Nullable error) {
        if(status){
            [wself.server seriesWithRefresh:YES andCompletion:^(NSArray<SNRSeries *> *series, NSError *error) {
                [tableView.refreshControl endRefreshing];
            }];
        }else{
            [tableView.refreshControl endRefreshing];
        }
    }];
}

#pragma mark - Navigation Protocol

-(void)addSeriesButtonTouchUpInside{
    [self presentViewController:[SNRSearchSeriesSheetViewController viewController] animated:YES completion:nil];
}

-(void)settingsButtonTouchUpInside{
    [self presentViewController:[SNRSettingsViewController viewController] animated:YES completion:nil];
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
    if (self.server.series && self.server.series.count) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.server seriesWithRefresh:NO andCompletion:nil];
    }
}

-(void)didUnsetActiveServer:(SNRServer *)server atIndex:(NSInteger)integer{
    if([SNRServerManager manager].servers.count){
        return;
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)didAddSeries:(NSDictionary<NSNumber *,SNRSeries *> *)series forServer:(SNRServer *)server{
    if(self.server != server ||
       !series.allKeys.count){
        return;
    }
    
    NSMutableArray *indexes = [[NSMutableArray alloc] init];
    NSMutableArray *reloadIndixes = [[NSMutableArray alloc] init];
    
    [series enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, SNRSeries * _Nonnull obj, BOOL * _Nonnull stop) {
        if(!key.integerValue){
            return [reloadIndixes addObject:[NSIndexPath indexPathForRow:key.integerValue inSection:0]];
        }
        [indexes addObject:[NSIndexPath indexPathForRow:key.integerValue inSection:0]];
    }];
    
    [self.tableView.refreshControl endRefreshing];
    
    [self.tableView beginUpdates];
    if(reloadIndixes.count){
        [self.tableView reloadRowsAtIndexPaths:reloadIndixes withRowAnimation:UITableViewRowAnimationNone];
    }
    
    if(indexes.count){
        [self.tableView insertRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationNone];
    }
    [self.tableView endUpdates];
}

-(void)didRemoveSeries:(NSDictionary<NSNumber *,SNRSeries *> *)series forServer:(SNRServer *)server{
    if(self.server != server ||
       !series.allKeys.count){
        return;
    }
    
    NSMutableArray *indexes = [[NSMutableArray alloc] init];
    
    [series enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, SNRSeries * _Nonnull obj, BOOL * _Nonnull stop) {
        [indexes addObject:[NSIndexPath indexPathForRow:key.integerValue inSection:0]];
    }];
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

#pragma mark - Setters

-(void)setTableView:(SNRBaseTableView *)tableView{
    _tableView = tableView;
    
    [tableView.refreshControl beginRefreshing];
}

-(void)setServer:(SNRServer *)server{
    _server = server;
    
    if(server && (!server.series || !server.series.count)){
        [server seriesWithRefresh:NO andCompletion:nil];
    }
}
@end
