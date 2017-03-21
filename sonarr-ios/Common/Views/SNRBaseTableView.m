//
//  SNRBaseTableView.m
//  sonarr-ios
//
//  Created by Harry Singh on 20/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRBaseTableView.h"
#import "UIColor+App.h"

@interface SNRBaseTableView()
@property (assign, nonatomic) IBInspectable BOOL pullToRefresh;
@end

@implementation SNRBaseTableView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
    }
    return self;
}

-(void)setPullToRefresh:(BOOL)pullToRefresh{
    _pullToRefresh = pullToRefresh;
    
    if(_pullToRefresh){
        self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        self.refreshControl.tintColor = [UIColor secondary];
    }
}

@end
