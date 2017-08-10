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

@interface SNRSeasonsViewController () <SNRSeasonHeaderCellProtocol>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *parallaxView;
@property (weak, nonatomic) IBOutlet UIImageView *parallaxImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *parallaxViewHeightConstraint;
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
    
    SNRImage *parallax = [self.series imageWithType:ImageTypeFanArt];
    self.parallaxImageView.image = parallax.image;
    
    [self animateParallaxImageViewToDefaultState:NO];
}

-(void)animateParallaxImageViewToDefaultState:(BOOL)animate{
    CGFloat frameWidth = CGRectGetWidth(self.view.frame);
    CGSize imageSize = self.parallaxImageView.image.size;
    
    if (CGSizeEqualToSize(CGSizeZero, imageSize)) {
        imageSize = kBannerSize;
    }
    
    CGFloat ratio = MIN(imageSize.height, imageSize.width) / MAX(imageSize.height, imageSize.width);
    
    self.parallaxViewHeightConstraint.constant = ratio * frameWidth;
    
    if (animate) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)didPan:(UIPanGestureRecognizer *)urgi{
    if (urgi.state == UIGestureRecognizerStateEnded) {
        [self animateParallaxImageViewToDefaultState:YES];
    } else {
        CGPoint velocity = [urgi velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        
        float slideFactor = 0.8 * slideMult;
        
        if (0 > velocity.y) {
            self.parallaxViewHeightConstraint.constant -= slideFactor;
        } else {
            self.parallaxViewHeightConstraint.constant += slideFactor;
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
    headerCell.contentView.backgroundColor = [UIColor blackColor];
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
    
}

#pragma mark - Setters

-(void)setSeries:(SNRSeries *)series{
    _series = series;
    
    self.headerExpanded = [[NSMutableDictionary alloc] init];
    
    for (int x = 0; x < series.seasons.count; x++) {
        [self.headerExpanded setValue:@(0) forKey:@(x).stringValue];
    }
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
        expanded ? [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic] : [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
