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
#import "SNRReleaseEpisodeView.h"
#import <MZFormSheetPresentationController/MZFormSheetPresentationViewController.h>

@interface SNRReleasesViewController () <SNRReleaseEpisodeViewProtocol, SNRReleaseCellProtocol>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SNRSeries *series;
@property (strong, nonatomic) SNREpisode* episode;
@property (strong, nonatomic) SNRServer *server;
@property (weak, nonatomic) IBOutlet SNRReleaseEpisodeView *releaseEpisodeView;
@end

@implementation SNRReleasesViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.releaseEpisodeView configureWithServer:self.server series:self.series andEpisode:self.episode];
    self.releaseEpisodeView.delegate = self;
}

#pragma mark - TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.episode.releases) {
        return floorf(65);
    }
    
    return floorf(50);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.episode.releases) {
        return 1;
    }
    
    return self.episode.releases.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.episode.releases) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"releasesLoadingCell" forIndexPath:indexPath];
        return cell;
    }
    
    SNRReleaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"releaseCell" forIndexPath:indexPath];
    [cell setRelease:self.episode.releases[indexPath.item]];
    cell.delegate = self;
    return cell;
}

#pragma mark - Custom sheet size

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
        if (error) {
            [wself fireDismissDelegateWithError:error];
        } else {
            if (!releases || !releases.count) {
                return [wself fireDismissDelegateWithError:[NSError errorWithDomain:@"com.sonarr.ios" code:1 userInfo:@{
                                                                                                                        NSLocalizedFailureReasonErrorKey : @"No releases found."
                                                                                                                        }]];
            }
            [wself.tableView reloadData];
        }
    }];
}

-(void)fireDismissDelegateWithError:(NSError *)error{
    __weak typeof(self) wself = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [wself.delegate didDismissWithError:error];
    }];
}

#pragma mark - Release Episode View Delegate

-(void)closeButtonTouchUpInside:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Release Cell Protocol

-(void)downloadRelease:(SNRRelease *)release withCompletion:(void (^)(SNRRelease * _Nullable, NSError * _Nullable))completion{
    [self.server downloadRelease:release onEpisode:self.episode withCompletion:^(SNRRelease * _Nullable release, NSError * _Nullable error) {
        if (completion) {
            completion(release, error);
        }
    }];
}

@end
