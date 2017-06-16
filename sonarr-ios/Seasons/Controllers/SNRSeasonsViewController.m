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

@interface SNRSeasonsViewController ()
@property (weak, nonatomic) IBOutlet SNRBaseTableView *tableView;
@property (strong, nonatomic) MXParallaxHeader *parallaxHeader;
@property (strong, nonatomic) SNRServer *server;
@property (strong, nonatomic) SNRSeries *series;
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
    return [self tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:NSIntegerMax - 1 inSection:section]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!indexPath.row){
        return 50;
    }
    return floorf(45);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == NSIntegerMax - 1){
        if(indexPath.section == NSIntegerMax - 1){
            SNRAddSeriesTableViewCell *seriesCell = (id)[tableView dequeueReusableCellWithIdentifier:@"seriesHeaderCell"];
            seriesCell.tag = indexPath.row;
            [seriesCell setSeries:self.series forServer:self.server];
            return (id)seriesCell;
        }
        
        SNRSeason *season = [[self.series.seasons reverseObjectEnumerator].allObjects objectAtIndex:indexPath.section];
        SNRSeasonHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"seasonHeaderCell"];
        [headerCell setSeason:season];
        
        return headerCell;
    }

    return nil;
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

@end
