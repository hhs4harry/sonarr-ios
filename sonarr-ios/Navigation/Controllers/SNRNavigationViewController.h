//
//  SNRNavigationViewController.h
//  sonarr-ios
//
//  Created by Harry Singh on 12/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SNRNavigationBarButtonProtocol <NSObject>
@optional
-(UIBarButtonItem *)backBarButton;
-(UIBarButtonItem *)rightBarButton;
@end

@interface SNRNavigationViewController : UINavigationController

@end
