//
//  SNRReleasesViewController.m
//  Sonarr
//
//  Created by Harry Singh on 14/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRReleasesViewController.h"
#import "SNRSeries.h"
#import "SNREpisode.h"
#import "SNRRelease.h"
#import "SNRServer.h"
#import "SNRReleaseCell.h"
#import <MZFormSheetPresentationController/MZFormSheetPresentationViewController.h>

@interface SNRReleasesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SNRSeries *series;
@property (strong, nonatomic) SNREpisode* episode;
@property (strong, nonatomic) SNRServer *server;
@end

@implementation SNRReleasesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return floorf(45);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.episode.releases.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SNRReleaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"releaseCell" forIndexPath:indexPath];
    [cell setRelease:self.episode.releases[indexPath.item]];
    return cell;
}

#pragma mark - Override custom sheet size

- (CGRect)contentViewFrameForPresentationController:(MZFormSheetPresentationController *)presentationController currentFrame:(CGRect)currentFrame {
    CGFloat viewW = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat viewH = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    if(viewW > viewH){
        return CGRectMake(viewW * 0.05, viewH * 0.05, viewW * 0.9, viewH * 0.9);
    }
    
    return CGRectMake(viewW * 0.05, viewH * 0.05, viewW * 0.9, viewH * 0.9);
}

#pragma mark - Setters/Getters

-(void)setServer:(SNRServer *)server series:(SNRSeries *)series andEpisode:(SNREpisode *)episode {
    self.server = server;
    self.series = series;
    self.episode = episode;
    
    __weak typeof(self) wself = self;
    [self.server releasesForEpisode:episode withCompletion:^(NSArray<SNRRelease *> * _Nullable releases, NSError * _Nullable error) {
        [wself.tableView reloadData];
    }];
}

@end
