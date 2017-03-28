//
//  SNRAddSeriesSheetViewController.m
//  sonarr-ios
//
//  Created by Harry Singh on 27/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRAddSeriesSheetViewController.h"
#import "SNRBaseTableView.h"
#import "SNRSeriesAddTableViewCell.h"
#import "NSString+check.h"
#import "SNRServer.h"
#import "SNRServerManager.h"
#import "SNRRefreshControl.h"

@interface SNRAddSeriesSheetViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SNRSeriesAddProtocol>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSString *currSearch;
@property (weak, nonatomic) IBOutlet SNRBaseTableView *tableView;
@property (strong, nonatomic) SNRServer *server;
@property (strong, nonatomic) NSArray *series;
@end

@implementation SNRAddSeriesSheetViewController

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
    
    [self.tableView.refreshControl addTarget:self action:@selector(didRequestPullToRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.searchBar becomeFirstResponder];
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
        return 50;
    }
    return CGRectGetWidth(self.view.frame)/2.5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.series.count ? : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.series.count){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"instructionsCell" forIndexPath:indexPath];
        return cell;
    }
    
    SNRSeriesAddTableViewCell *seriesCell = [tableView dequeueReusableCellWithIdentifier:@"seriesAddCell" forIndexPath:indexPath];
    seriesCell.tag = indexPath.row;
    seriesCell.delegate = self;
    [seriesCell setSeries:[self.series objectAtIndex:indexPath.row] forServer:self.server];
    [seriesCell scrollViewDidScroll:self.tableView];
    return seriesCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    SNRSeriesTableViewCell *seriesCell = [tableView cellForRowAtIndexPath:indexPath];
    [seriesCell setSelected:YES];
    return;
}

-(void)didRequestPullToRefresh:(id)sender{
    if(![self.searchBar.text nonEmpty]){
        [self.tableView.refreshControl endRefreshing];
        return;
    }
    
    [self runSearch];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.series.count){
        for (SNRSeriesAddTableViewCell *seriesCell in self.tableView.visibleCells) {
            if(![seriesCell isKindOfClass:[SNRSeriesAddTableViewCell class]]){
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
        wself.series = series;
        
        [wself.tableView.refreshControl endRefreshing];
        [wself.tableView reloadData];
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
    if(![searchText isEqualToString:self.currSearch]){
        self.series = nil;
        [self.tableView reloadData];
    }
}

+(CGSize)contentViewSize{
    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.9, CGRectGetHeight([UIScreen mainScreen].bounds) * 0.6);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.view endEditing:[self.searchBar resignFirstResponder]];
}
@end
