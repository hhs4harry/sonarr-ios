//
//  SNRRefreshControl.h
//  sonarr-ios
//
//  Created by Harry Singh on 28/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SNRRefreshControlProtocol
-(void)didRequestRefresh;

@end

@interface SNRRefreshControl : UIRefreshControl
@property (weak, nonatomic) id<SNRRefreshControlProtocol> delegate;
@end
