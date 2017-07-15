//
//  SNRSeasonsViewController.m
//  sonarr-ios
//
//  Created by Harry Singh on 15/06/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRSeasonsViewController.h"
#import "SNRImageView.h"
#import "SNRAddSeriesTableViewCell.h"
#import "SNRServer.h"
#import "SNRServerManager.h"
#import "SNRBaseTableView.h"
#import <MXParallaxHeader/MXParallaxHeader.h>
#import <MXParallaxHeader/MXScrollView.h>
#import "SNRActivityIndicatorView.h"
#import "SNRSeason.h"
#import "SNRSeasonHeaderCell.h"
#import "SNREpisodeCell.h"
#import "ViewController.h"
@interface SNRSeasonsViewController () <SNRSeasonHeaderCellProtocol>
@property (weak, nonatomic) IBOutlet SNRBaseTableView *tableView;
@property (strong, nonatomic) MXParallaxHeader *parallaxHeader;
@property (strong, nonatomic) SNRServer *server;
@property (strong, nonatomic) SNRSeries *series;
@property (strong, nonatomic) NSMutableDictionary *headerExpanded;
@end

@implementation SNRSeasonsViewController

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.server = [SNRServerManager manager].activeServer;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = self.series.title;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SeasonHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"SeasonHeader"];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if(!self.parallaxHeader){
        SNRAddSeriesTableViewCell *cell = (id)[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:NSIntegerMax - 1 inSection:NSIntegerMax - 1]];
        
        self.parallaxHeader = [[MXParallaxHeader alloc] init];
        self.parallaxHeader.view = cell.contentView;
        self.tableView.parallaxHeader = self.parallaxHeader;
    }
    
    [self updateParallaxHeaderView];
}

#pragma mark - Getter/Setter

-(void)setSeries:(SNRSeries *)series{
    _series = series;
    
    self.headerExpanded = [[NSMutableDictionary alloc] init];
    
    for (int x = 0; x < series.seasons.count; x++) {
        [self.headerExpanded setValue:@(0) forKey:@(x).stringValue];
    }
    
    __weak typeof(self) wself = self;
    [[SNRServerManager manager].activeServer episodesForSeries:series withCompletion:^(NSArray<SNREpisode *> * _Nullable episodes, NSError * _Nullable error) {
        ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [vc setSeries:self.series];
        [self.navigationController pushViewController:vc animated:YES];
        
        [wself.headerExpanded enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSNumber *  _Nonnull obj, BOOL * _Nonnull stop) {
            if(obj.boolValue){
                [wself.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:key.integerValue] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    }];
}

#pragma mark - Navigation

-(UIBarButtonItem *)rightBarButton{
    for (SNRSeries *series in self.server.series) {
        if(series.tvdbId.integerValue == self.series.tvdbId.integerValue){
            return nil;
        }
    }
    
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                         target:self
                                                         action:@selector(addSeriesButtonTouchUpInside)];
}

-(void)addSeriesButtonTouchUpInside{
    [SNRActivityIndicatorView showOnTint:YES onView:self.view];
    
    __weak typeof(self) wself = self;
    [self.server addSeries:self.series withCompletion:^(SNRSeries * _Nullable series, NSError * _Nullable error) {
        if(series){
            return [wself dismissViewControllerAnimated:YES completion:nil];
        }
        
        [SNRActivityIndicatorView showOnTint:NO onView:wself.view];
    }];
}

#pragma mark - TableView

-(void)updateParallaxHeaderView{
    CGRect frame =  self.view.frame;
    CGFloat frameM = MIN(frame.size.width, frame.size.height);
    
    CGFloat minimunHeight = 130.0f;
    CGFloat propHeight = ((1080.0f / 1920.0f) * frameM) + 60.0;
    
    CGFloat height = MAX(propHeight, minimunHeight);
    
    self.tableView.parallaxHeader.height = height;
    self.tableView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.tableView.parallaxHeader.minimumHeight = minimunHeight;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.series.seasons.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SNRSeason *season = [self.series.seasons objectAtIndex:section];
    SNRSeasonHeaderCell *headerCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SeasonHeader"];
    [headerCell setSeason:season];
    [headerCell setExpanded:[self.headerExpanded[@(section).stringValue] boolValue]];
    headerCell.delegate = self;
    return headerCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row ? floorf(45) : 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (![self.headerExpanded[@(section).stringValue] boolValue]) {
        return 0;
    }
    SNRSeason *season = [self.series.seasons objectAtIndex:section];
    return season.episodes.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"here");
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == NSIntegerMax - 1 && indexPath.section == NSIntegerMax - 1){
        SNRAddSeriesTableViewCell *seriesCell = (id)[tableView dequeueReusableCellWithIdentifier:@"seriesHeaderCell"];
        seriesCell.tag = indexPath.row;
        [seriesCell setSeries:self.series forServer:self.server];
        return (id)seriesCell;
    }
    
    SNRSeason *season = [self.series.seasons objectAtIndex:indexPath.section];
    SNREpisode *episode = [season.episodes objectAtIndex:indexPath.row];
    SNREpisodeCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:@"episodeCell" forIndexPath:indexPath];
    [cell setEpisode:episode];
    return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    SNRAddSeriesDetailsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    [cell becomeFirstResponder];
}

#pragma mark - Orientation Transition

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [self updateParallaxHeaderView];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - Season Header Cell Protocol

- (void)season:(SNRSeason *)season expanded:(BOOL)expanded {
    NSInteger section = [self.series.seasons indexOfObject:season];
    self.headerExpanded[@(section).stringValue] = @(expanded);
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (int x = 0; x < season.episodes.count; x++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:x inSection:section]];
    }
    
    if (indexPaths.count) {
#warning CAUSING CRASH ON iOS 11
//        [self.tableView beginUpdates];
//        [self.tableView deleteSections:[[NSIndexSet alloc] initWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.tableView insertSections:[[NSIndexSet alloc] initWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.tableView endUpdates];
        expanded ? [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic] : [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.tableView reloadData];
    }
}

@end
