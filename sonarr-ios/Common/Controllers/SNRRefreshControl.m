//
//  SNRRefreshControl.m
//  sonarr-ios
//
//  Created by Harry Singh on 28/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRRefreshControl.h"
#import "UIColor+App.h"

@interface SNRRefreshControl()
@property (strong, nonatomic) NSOperationQueue *refreshQueue;
@property (assign, nonatomic) BOOL refreshing;
@property (assign, nonatomic) CGRect actualRect;
@end

@implementation SNRRefreshControl

@synthesize refreshing;

-(instancetype)init{
    self = [super init];
    if(self){
        self.refreshQueue = [[NSOperationQueue alloc] init];
        self.refreshQueue.maxConcurrentOperationCount = 1;
        self.refreshQueue.underlyingQueue = dispatch_get_main_queue();
        
        self.tintColor = [UIColor secondary];
        self.backgroundColor = [UIColor primary];
        
        self.actualRect = self.bounds;
    }
    return self;
}

-(void)beginRefreshing{
    [super beginRefreshing];
    
    if (((UITableView *)self.superview).contentOffset.y != -CGRectGetHeight(self.actualRect)) {
        __weak typeof(self) wself = self;
        [self.refreshQueue addOperationWithBlock:^{
            wself.refreshQueue.suspended = YES;

            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(){
                [wself setFrame:CGRectMake(0, -CGRectGetHeight(wself.actualRect), CGRectGetWidth(wself.frame), CGRectGetHeight(wself.actualRect))];
                ((UITableView *)wself.superview).contentOffset = CGPointMake(0,
                                                                            -CGRectGetHeight(wself.actualRect));
            } completion:^(BOOL finished) {
                wself.refreshQueue.suspended = NO;
            }];
        }];
    }
}

-(void)endRefreshing{
    if (((UITableView *)self.superview).contentOffset.y != 0) {
        __weak typeof(self) wself = self;
        [self.refreshQueue addOperationWithBlock:^{
            wself.refreshQueue.suspended = YES;
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
                ((UITableView *)wself.superview).contentOffset = CGPointZero;
            } completion:^(BOOL finished) {
                [super endRefreshing];
                wself.refreshQueue.suspended = NO;
            }];
        }];
    }
}

@end
