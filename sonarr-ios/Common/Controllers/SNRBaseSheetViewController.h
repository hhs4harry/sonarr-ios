//
//  SNRBaseSheetViewController.h
//  sonarr-ios
//
//  Created by Harry Singh on 12/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRBaseViewController.h"

@protocol SNRBaseSheetViewControllerProtocol <NSObject>
@required
+(UIViewController *)formViewController;
@end

@interface SNRBaseSheetViewController : SNRBaseViewController <SNRBaseSheetViewControllerProtocol>

@end
