//
//  SNRBaseViewController.h
//  sonarr-ios
//
//  Created by Harry Singh on 12/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SNRBaseViewControllerProtocol <NSObject>
@required
+(NSString * _Nonnull)storyboardIdentifier;
+(UIStoryboard * _Nonnull)vcStoryboard;
+(UIViewController * _Nonnull)viewController;
@end

@interface SNRBaseViewController : UIViewController <SNRBaseViewControllerProtocol>
-(void)showSpinner:(BOOL)show;
-(void)showMessage:(NSString * _Nonnull)message withTitle:(NSString * _Nonnull)title;

@end
