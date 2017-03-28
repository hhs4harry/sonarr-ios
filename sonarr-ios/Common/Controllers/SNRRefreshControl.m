//
//  SNRRefreshControl.m
//  sonarr-ios
//
//  Created by Harry Singh on 28/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRRefreshControl.h"

@interface SNRRefreshControl()
@end

@implementation SNRRefreshControl

-(void)beginRefreshing{
    [super beginRefreshing];
    
    if (((UITableView *)self.superview).contentOffset.y == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
                ((UITableView *)self.superview).contentOffset = CGPointMake(0,
                                                                            -self.frame.size.height);
                [self.superview bringSubviewToFront:self];
            } completion:nil];
        });
    }
}

-(void)endRefreshing{
    [super endRefreshing];
    
    if(self.refreshing){
        if (((UITableView *)self.superview).contentOffset.y != 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
                    ((UITableView *)self.superview).contentOffset = CGPointZero;
                } completion:nil];
            });
        }
    }
}
@end
