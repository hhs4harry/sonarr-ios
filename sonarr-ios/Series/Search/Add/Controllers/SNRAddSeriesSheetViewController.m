//
//  SNRAddSeriesSheetViewController.m
//  sonarr-ios
//
//  Created by Harry Singh on 30/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRAddSeriesSheetViewController.h"
#import "SNRSeries.h"
#import "SNRAddSeriesTableViewCell.h"
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
    
    [self updateParallaxHeaderViewWithOrientation:[UIDevice currentDevice].orientation];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - TableView

-(void)updateParallaxHeaderViewWithOrientation:(UIDeviceOrientation)orientation{
    CGFloat minimunHeight = 130;
    CGFloat height = MAX(CGRectGetWidth(self.view.frame) * 0.5, minimunHeight);
    
    if(orientation != UIDeviceOrientationLandscapeLeft ||
       orientation != UIDeviceOrientationLandscapeRight){
        height = MAX(CGRectGetHeight(self.view.frame) * 0.4, minimunHeight);
    }
    
    MXParallaxHeader *header = [[MXParallaxHeader alloc] init];
    header.view = (id)[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:NSIntegerMax - 1 inSection:0]].contentView;
    self.tableView.parallaxHeader = header;
    self.tableView.parallaxHeader.height = height;
    self.tableView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.tableView.parallaxHeader.minimumHeight = minimunHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return floorf(50);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == NSIntegerMax - 1){
        SNRAddSeriesTableViewCell *seriesCell = (id)[tableView dequeueReusableCellWithIdentifier:@"seriesHeaderCell"];
        seriesCell.tag = indexPath.row;
        [seriesCell setSeries:self.series forServer:self.server];
        return (id)seriesCell;
    }
    return [[UITableViewCell alloc] init];
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
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self updateParallaxHeaderViewWithOrientation:[UIDevice currentDevice].orientation];
}
@end
