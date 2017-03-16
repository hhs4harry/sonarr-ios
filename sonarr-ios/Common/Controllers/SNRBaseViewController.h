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
+(NSString * __nonnull)storyboardIdentifier;
+(UIStoryboard * __nonnull)vcStoryboard;

@end

@interface SNRBaseViewController : UIViewController <SNRBaseViewControllerProtocol>

@end
