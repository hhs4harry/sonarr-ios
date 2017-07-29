//
//  SNRServerCell.h
//  Sonarr
//
//  Created by Harry Singh on 16/07/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNRSettingsCell.h"
@class SNRServer;

@interface SNRServerCell : SNRSettingsCell
-(void)configureWithServer:(SNRServer *)server;
@end
