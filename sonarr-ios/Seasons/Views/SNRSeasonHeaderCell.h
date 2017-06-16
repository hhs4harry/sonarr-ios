//
//  SNRSeasonHeaderCell.h
//  sonarr-ios
//
//  Created by Harry Singh on 16/06/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNRSeason.h"

@interface SNRSeasonHeaderCell : UITableViewCell
-(void)setSeason:(SNRSeason *)season;

@end
