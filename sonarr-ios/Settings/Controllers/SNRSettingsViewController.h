//
//  SNRSettingsViewController.h
//  Sonarr
//
//  Created by Harry Singh on 14/07/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRBaseSheetViewController.h"

@protocol SNRSettingsProtocol
-(void)openSettings:(BOOL)open;
@end

@interface SNRSettingsViewController : SNRBaseViewController
@property (weak, nonatomic) id<SNRSettingsProtocol> delegate;
@end
