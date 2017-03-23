//
//  SNRSeriesTableViewCell.h
//  sonarr-ios
//
//  Created by Harry Singh on 21/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNRSeries;
@class SNRServer;

@interface SNRSeriesTableViewCell : UITableViewCell
-(void)setSeries:(SNRSeries *)series forServer:(SNRServer *)server;

@end
