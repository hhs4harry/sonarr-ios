//
//  SNRSeasonHeaderCell.h
//  sonarr-ios
//
//  Created by Harry Singh on 16/06/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNRSeason.h"

@protocol SNRSeasonHeaderCellProtocol
@required
-(void)season:(SNRSeason *)season expanded:(BOOL)expanded;
@end

@interface SNRSeasonHeaderCell : UITableViewHeaderFooterView
@property (weak) id<SNRSeasonHeaderCellProtocol> delegate;
-(void)setSeason:(SNRSeason *)season;
-(void)setExpanded:(BOOL)expanded;
@end
