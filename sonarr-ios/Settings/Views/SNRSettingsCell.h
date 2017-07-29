//
//  SNRSettingsCell.h
//  Sonarr
//
//  Created by Harry Singh on 28/07/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNRSettingsCell;
@class SNRServerConfig;
@class SNRStatus;

@protocol SNRSettingsCellProtocol
-(void)expanded:(BOOL)expanded cell:(SNRSettingsCell *)cell;
-(void)addServerWithConfig:(SNRServerConfig *)config andCompletion:(void(^)(SNRStatus *status, NSError *error))completion;
@end

@interface SNRSettingsCell : UITableViewCell
@property (assign, nonatomic) id<SNRSettingsCellProtocol> delegate;

-(BOOL)validateInput;
-(void)resetInput;
-(void)showError:(BOOL)show onTextField:(UITextField *)textfield;
@end
