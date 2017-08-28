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
#import "SNRConstants.h"
#import "SNRParallaxView.h"
#import "SNRReleasesViewController.h"
#import <MZFormSheetPresentationController/MZFormSheetPresentationViewController.h>
#import "SNRNavigationViewController.h"
#import "SNRConstants.h"

@interface SNRSeasonsViewController () <SNRSeasonHeaderCellProtocol, SNREpisodeCellProtocol, SNRReleaseViewControllerProtocol, SNRNavigationBarButtonProtocol>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SNRParallaxView *parallaxView;

@property (strong, nonatomic) SNRSeries *series;
@property (strong, nonatomic) SNRServer *server;
@property (strong, nonatomic) NSMutableDictionary *headerExpanded;
@end

@implementation SNRSeasonsViewController

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.server = [SNRServerManager manager].activeServer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SeasonHeader" bundle:nil]forHeaderFooterViewReuseIdentifier:@"SeasonHeader"];
    [self.parallaxView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = self.series.title;
    
    [self.parallaxView configureWithSeries:self.series forServer:self.server];
    [self.tableView.panGestureRecognizer addTarget:self action:@selector(didPan:)];
}

-(void)didPan:(UIPanGestureRecognizer *)urgi {
    if (urgi.view == self.parallaxView) {
        [self.parallaxView didPan:urgi];
    } else {
        CGPoint translation = [urgi translationInView:self.tableView];
        
        if (translation.y < 0) {
            if ([self.parallaxView didPan:urgi]) {
                [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, 0)];
            }
        } else if (translation.y > 0) {
            if (self.tableView.contentOffset.y == 0) {
                if([self.parallaxView didPan:urgi]) {
                    [self.tableView setContentOffset:CGPointMake(0, 0)];
                }
            }
        }
    }
}

#pragma mark - TableView

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
    SNRSeason *season = [self.series.seasons objectAtIndex:indexPath.section];
    if (!season.episodes && !season.episodes.count) {
        return floor(65);
    }
    
    return floorf(45);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (![self.headerExpanded[@(section).stringValue] boolValue]) {
        return 0;
    }
    
    SNRSeason *season = [self.series.seasons objectAtIndex:section];
    if (season.episodes && season.episodes.count) {
        return season.episodes.count;
    }
    return 1;
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
    SNRSeason *season = [self.series.seasons objectAtIndex:indexPath.section];
    if (season.episodes && season.episodes.count) {
        SNREpisode *episode = [season.episodes objectAtIndex:indexPath.row];
        SNREpisodeCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:@"episodeCell" forIndexPath:indexPath];
        [cell setEpisode:episode];
        cell.delegate = self;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"episodeLoadingCell" forIndexPath:indexPath];
    return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
}

#pragma mark - Setters

-(void)setSeries:(SNRSeries *)series{
    _series = series;
    
    if (series.seasons && series.seasons.count) {
        if (!((SNRSeason *)series.seasons.firstObject).episodes || ((SNRSeason *)series.seasons.firstObject).episodes.count) {
            __weak typeof(self) wself = self;
            [self.server episodesForSeries:series withCompletion:^(NSArray<SNREpisode *> * _Nullable episodes, NSError * _Nullable error) {
                [wself.tableView reloadData];
            }];
        }
        
        self.headerExpanded = [[NSMutableDictionary alloc] init];
        
        for (int x = 0; x < series.seasons.count; x++) {
            [self.headerExpanded setValue:@(0) forKey:@(x).stringValue];
        }
    }
}

#pragma mark - Season Header Cell Protocol

- (void)season:(SNRSeason *)season expanded:(BOOL)expanded {
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSInteger section = [self.series.seasons indexOfObject:season];

    if (expanded) {
        self.headerExpanded[@(section).stringValue] = @(expanded);
        
        for (int x = 0; x < [self tableView:self.tableView numberOfRowsInSection:section]; x++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:x inSection:section]];
        }
    } else {
        for (int x = 0; x < [self tableView:self.tableView numberOfRowsInSection:section]; x++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:x inSection:section]];
        }
        
        self.headerExpanded[@(section).stringValue] = @(expanded);
    }
    
    if (indexPaths.count) {
        expanded ? [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic] : [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Episode Cell Protocol

-(void)automaticSearchForEpisode:(SNREpisode *)episode {
    
}

-(void)manualSearchForEpisode:(SNREpisode *)episode {
    MZFormSheetPresentationViewController *sheetViewPresentationController = (id)[SNRReleasesViewController viewController];
    SNRReleasesViewController *releaseViewController = (id)sheetViewPresentationController.contentViewController;
    releaseViewController.delegate = self;
    [releaseViewController setServer:self.server series:self.series andEpisode:episode];
    [self presentViewController:sheetViewPresentationController animated:YES completion:nil];
}

#pragma mark - Release View Controller Delegate

-(void)didDismissWithError:(NSError *)error{
#warning handle error
}

#pragma mark - Navigation Protocol

-(UIBarButtonItem *)backBarButton{
    UIBarButtonItem *item = [SNRConstants backButtonTarget:self andSelector:@selector(backButtonTouched)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonTouched)];
    item.customView.gestureRecognizers = @[tapGesture];
    
    return item;
}

-(void)backButtonTouched{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
