//
//  SNRAddSeriesSheetViewController.m
//  sonarr-ios
//
//  Created by Harry Singh on 30/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRAddSeriesSheetViewController.h"
#import "SNRAddSeriesTableViewCell.h"
#import "SNRAddSeriesDetailsTableViewCell.h"
#import "SNRSeries.h"
#import "SNRBaseTableView.h"
#import "SNRServerManager.h"
#import "SNRServer.h"
#import <MZFormSheetPresentationController.h>
#import <MXParallaxHeader/MXParallaxHeader.h>
#import <MXParallaxHeader/MXScrollView.h>

@interface SNRAddSeriesSheetViewController ()
@property (weak, nonatomic) IBOutlet SNRBaseTableView *tableView;
@property (strong, nonatomic) SNRServer *server;
@property (strong, nonatomic) SNRSeries *series;
@property (strong, nonatomic) MXParallaxHeader *parallaxHeader;
@end

@implementation SNRAddSeriesSheetViewController

#pragma mark - Life cycle

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.server = [SNRServerManager manager].activeServer;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = self.series.title;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if(!self.parallaxHeader){
        self.parallaxHeader = [[MXParallaxHeader alloc] init];
        self.parallaxHeader.view = (id)[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:NSIntegerMax - 1 inSection:0]].contentView;
        self.tableView.parallaxHeader = self.parallaxHeader;
    }

    [self updateParallaxHeaderView];
}

#pragma mark - TableView

-(void)updateParallaxHeaderView{
    CGRect frame =  [self contentViewFrameForPresentationController:nil currentFrame:[UIScreen mainScreen].bounds];
    CGFloat frameH = CGRectGetHeight(frame);
    
    CGFloat minimunHeight = 130;
    CGFloat height = MAX(frameH * 0.5, minimunHeight);
    
    self.tableView.parallaxHeader.height = height;
    self.tableView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.tableView.parallaxHeader.minimumHeight = minimunHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return floorf(45);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return SeriesDetailCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == NSIntegerMax - 1){
        SNRAddSeriesTableViewCell *seriesCell = (id)[tableView dequeueReusableCellWithIdentifier:@"seriesHeaderCell"];
        seriesCell.tag = indexPath.row;
        [seriesCell setSeries:self.series forServer:self.server];
        return (id)seriesCell;
    }
    
    SNRAddSeriesDetailsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"seriesDetailCell" forIndexPath:indexPath];
    [cell setSeries:self.series seriesDetailType:indexPath.row];
    return cell;
}

#pragma mark - Base View Controller

- (BOOL)shouldUseContentViewFrameForPresentationController:(MZFormSheetPresentationController *)presentationController {
    return YES;
}

- (CGRect)contentViewFrameForPresentationController:(MZFormSheetPresentationController *)presentationController currentFrame:(CGRect)currentFrame {
    CGFloat viewW = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat viewH = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    if(viewW > viewH){
        return CGRectMake(viewW * 0.1, viewH * 0.05, viewW * 0.8, viewH * 0.9);
    }
    
    return CGRectMake(viewW * 0.05, viewH * 0.15, viewW * 0.9, viewH * 0.7);
}

#pragma mark - Orientation Transition

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [self updateParallaxHeaderView];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}
@end
