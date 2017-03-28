//
//  SNRBaseTableView.m
//  sonarr-ios
//
//  Created by Harry Singh on 20/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRBaseTableView.h"
#import "UIColor+App.h"
#import "SNRRefreshControl.h"

@interface SNRBaseTableView()
@property (assign, nonatomic) IBInspectable BOOL pullToRefresh;
@property (strong, nonatomic) SNRRefreshControl *refreshControl;
@end

@implementation SNRBaseTableView
@synthesize refreshControl;

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
    }
    return self;
}

-(void)reloadData{
    [UIView transitionWithView:self
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^(void) {
                        [super reloadData];
                    } completion:nil];
}

-(void)setPullToRefresh:(BOOL)pullToRefresh{
    _pullToRefresh = pullToRefresh;
    
    if(_pullToRefresh){
        self.refreshControl = [[SNRRefreshControl alloc] init];
        [self insertSubview:self.refreshControl atIndex:0];
        self.refreshControl.tintColor = [UIColor secondary];
        self.refreshControl.backgroundColor = [UIColor primary];
    }
}

@end
