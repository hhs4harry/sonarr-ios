//
//  SNRAddSeriesViewController.m
//  sonarr-ios
//
//  Created by Harry Singh on 30/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRAddSeriesViewController.h"
#import "SNRAddSeriesTableViewCell.h"
#import "SNRAddSeriesDetailsTableViewCell.h"
#import "SNRSeries.h"
#import "SNRBaseTableView.h"
#import "SNRServerManager.h"
#import "SNRServer.h"
#import <MZFormSheetPresentationController.h>
#import <MXParallaxHeader/MXParallaxHeader.h>
#import <MXParallaxHeader/MXScrollView.h>
#import "SNRNavigationViewController.h"
#import "SNRActivityIndicatorView.h"
#import "SNRAddSeriesDetailsSwitchTableViewCell.h"
#import "SNRAddSeriesDetailsInfoTableViewCell.h"
#import "SNRConstants.h"

@interface SNRAddSeriesViewController () <SNRNavigationBarButtonProtocol>
@property (weak, nonatomic) IBOutlet SNRBaseTableView *tableView;
@property (strong, nonatomic) SNRServer *server;
@property (strong, nonatomic) SNRSeries *series;
@property (strong, nonatomic) MXParallaxHeader *parallaxHeader;
@end

@implementation SNRAddSeriesViewController

#pragma mark - Life cycle

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
        SNRAddSeriesTableViewCell *cell = (id)[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:NSIntegerMax - 1 inSection:0]];
        
        self.parallaxHeader = [[MXParallaxHeader alloc] init];
        self.parallaxHeader.view = cell.contentView;
        self.tableView.parallaxHeader = self.parallaxHeader;
    }

    [self updateParallaxHeaderView];
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!indexPath.row){
        return 50;
    }
    return floorf(45);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return SeriesDetailCount + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == NSIntegerMax - 1){
        SNRAddSeriesTableViewCell *seriesCell = (id)[tableView dequeueReusableCellWithIdentifier:@"seriesHeaderCell"];
        seriesCell.tag = indexPath.row;
        [seriesCell setSeries:self.series forServer:self.server];
        return (id)seriesCell;
    }
    
    if(!indexPath.row){
        SNRAddSeriesDetailsInfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"seriesDetailInfoCell" forIndexPath:indexPath];
        [cell setSeries:self.series];
        return cell;
    }
    
    NSInteger index = indexPath.row - 1;
    
    if(index == SeriesDetailCount){
        SNRAddSeriesDetailsSwitchTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"seriesDetailSwitchCell" forIndexPath:indexPath];
        [cell setSeries:self.series];
        return cell;
    }
    
    SNRAddSeriesDetailsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"seriesDetailCell" forIndexPath:indexPath];
    [cell setSeries:self.series seriesDetailType:index];
    return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == SeriesDetailCount){
        return nil;
    }
    
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    SNRAddSeriesDetailsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell becomeFirstResponder];
}

#pragma mark - Orientation Transition

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [self updateParallaxHeaderView];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - Navigation Protocol

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

-(UIBarButtonItem *)backBarButton{
    UIBarButtonItem *item = [SNRConstants backButtonTarget:self andSelector:@selector(backButtonTouched)];
    return item;
}

-(void)backButtonTouched{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
