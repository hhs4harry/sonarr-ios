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

@interface SNRBaseTableView() <SNRRefreshControlProtocol>
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
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.fillMode = kCAFillModeBoth;

    [self.layer addAnimation:transition forKey:@"reloadData"];
    [super reloadData];
}

-(void)setPullToRefresh:(BOOL)pullToRefresh{
    _pullToRefresh = pullToRefresh;
    
    if(_pullToRefresh){
        self.refreshControl = [[SNRRefreshControl alloc] init];
        self.refreshControl.delegate = self;
        [self insertSubview:self.refreshControl atIndex:0];
    }
}

#pragma mark - SNRRefreshControlProtocol

-(void)didRequestRefresh{
    if (self.delegate) {
        [((id<SNRBaseTableViewProtocol>)self.delegate) didRequestRefresh:self];
    }
}

@end
