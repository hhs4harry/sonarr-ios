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

@interface SNRSeriesViewController () <SNRNavigationBarButtonProtocol>
@property (weak, nonatomic) IBOutlet SNRBaseTableView *tableView;
@property (strong, nonatomic) SNRServer *server;
@end

@implementation SNRSeriesViewController

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.server = [SNRServerManager manager].activeServer;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView.refreshControl addTarget:self action:@selector(didRequestPullToRefresh:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - TableView

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    //    return self.serverManager.servers.count ? : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(!self.serverManager.servers.count){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noSeriesCell" forIndexPath:indexPath];
        return cell;
//    }
    
//    SNRSeriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seriesCell" forIndexPath:indexPath];
//    [cell setServer:[self.serverManager.servers objectAtIndex:indexPath.row]];
//    return cell;
}

#pragma mark - Navigation Protocol

-(void)addSeriesButtonTouchUpInside{
    [self.tableView.refreshControl endRefreshing];
    
//    [self presentViewController:[SNRAddServerPopUpViewController formViewController] animated:YES completion:nil];
}

-(UIBarButtonItem *)rightBarButton{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                         target:self
                                                         action:@selector(addSeriesButtonTouchUpInside)];
}

#pragma mark - Pull to refresh

-(void)didRequestPullToRefresh:(id)sender{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.refreshControl endRefreshing];
    });
}

@end
