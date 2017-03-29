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
@property (assign, nonatomic) CGRect actualRect;
@end

@implementation SNRRefreshControl

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
        [self.refreshQueue addOperationWithBlock:^{
            self.refreshQueue.suspended = YES;

            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
                [self setFrame:CGRectMake(0, -CGRectGetHeight(self.actualRect), CGRectGetWidth(self.frame), CGRectGetHeight(self.actualRect))];
                ((UITableView *)self.superview).contentOffset = CGPointMake(0,
                                                                            -CGRectGetHeight(self.actualRect));
            } completion:^(BOOL finished) {
                self.refreshQueue.suspended = NO;
            }];
        }];
    }
}

-(void)endRefreshing{
    if (((UITableView *)self.superview).contentOffset.y != 0) {
        [self.refreshQueue addOperationWithBlock:^{
            self.refreshQueue.suspended = YES;
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
                ((UITableView *)self.superview).contentOffset = CGPointZero;
            } completion:^(BOOL finished) {
                [super endRefreshing];
                self.refreshQueue.suspended = NO;
            }];
        }];
    }
}
@end
