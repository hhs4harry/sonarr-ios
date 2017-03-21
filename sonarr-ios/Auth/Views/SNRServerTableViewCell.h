//
//  SNRServerTableViewCell.h
//  sonarr-ios
//
//  Created by Harry Singh on 20/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNRServer;

@interface SNRServerTableViewCell : UITableViewCell

-(void)setServer:(SNRServer *)server;

@end
