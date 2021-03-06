//
//  SNRSearchSeriesSheetViewController.m
//  sonarr-ios
//
//  Created by Harry Singh on 27/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRSearchSeriesViewController.h"
#import "SNRBaseTableView.h"
#import "SNRSearchSeriesTableViewCell.h"
#import "NSString+check.h"
#import "SNRServer.h"
#import "SNRServerManager.h"
#import "SNRRefreshControl.h"
#import "SNRSeriesViewController.h"
#import "SNRAddSeriesViewController.h"
#import "SNRConstants.h"

@interface SNRSearchSeriesViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SNRSeriesAddProtocol, SNRBaseTableViewProtocol>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSString *currSearch;
@property (weak, nonatomic) IBOutlet SNRBaseTableView *tableView;
@property (strong, nonatomic) SNRServer *server;
@property (strong, nonatomic) NSArray *series;
@end

@implementation SNRSearchSeriesViewController

#pragma mark - Life cycle

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.server = [SNRServerManager manager].activeServer;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = @"Search";
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.searchBar resignFirstResponder];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self.searchBar resignFirstResponder];
}

#pragma mark - TableView

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.series.count){
        return kNoSeriesHeight;
    }
    
    return (kBannerSizeRatio * MIN(CGRectGetHeight(self.tableView.frame), CGRectGetWidth(self.tableView.frame))) * kSeriesHeightPercentage;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.series.count ? : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.series.count){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"instructionsCell" forIndexPath:indexPath];
        return cell;
    }
    
    SNRSearchSeriesTableViewCell *seriesCell = [tableView dequeueReusableCellWithIdentifier:@"seriesAddCell" forIndexPath:indexPath];
    seriesCell.tag = indexPath.row;
    seriesCell.delegate = self;
    [seriesCell setSeries:[self.series objectAtIndex:indexPath.row] forServer:self.server];
    [seriesCell scrollViewDidScroll:self.tableView];
    return seriesCell;
}

-(void)didRequestRefresh:(SNRBaseTableView *)tableView{
    if(![self.searchBar.text nonEmpty]){
        [self.tableView.refreshControl endRefreshing];
        return;
    }
    
    [self runSearch];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.series.count){
        for (SNRSearchSeriesTableViewCell *seriesCell in self.tableView.visibleCells) {
            if(![seriesCell respondsToSelector:@selector(scrollViewDidScroll:)]){
                continue;
            }
            
            [seriesCell scrollViewDidScroll:scrollView];
        }
    }
}

#pragma mark - SNRSeriesAddCell delegate

-(void)didTapAddSeries:(SNRSeries *)series{
    NSMutableArray *serverSeries = self.server.series.mutableCopy;
    [serverSeries addObject:series];
}

#pragma mark - Search Bar delegate

-(void)runSearch{
    self.currSearch = self.searchBar.text;
    [self.tableView.refreshControl beginRefreshing];

    __weak typeof(self) wself = self;
    [self.server searchForSeries:self.searchBar.text withCompletion:^(NSArray<SNRSeries *> *series, NSError *error) {
        if(series){
            wself.series = series;
            [wself.tableView reloadData];
        }
        [wself.tableView.refreshControl endRefreshing];
    }];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if(![searchBar.text nonEmpty]){
        return;
    }
    
    if([searchBar.text isEqualToString:self.currSearch]){
        return;
    }
    
    [self.searchBar resignFirstResponder];
    [self runSearch];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(![searchText nonEmpty] ||
       ![self.currSearch nonEmpty] ||
       !self.series.count){
        return;
    }
    
    if(![searchText isEqualToString:self.currSearch]){
        self.series = nil;
        self.currSearch = nil;
        [self.tableView reloadData];
    }
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [((SNRAddSeriesViewController *)segue.destinationViewController) setSeries:[self.series objectAtIndex:self.tableView.indexPathForSelectedRow.row]];
    [super prepareForSegue:segue sender:sender];
}

@end
