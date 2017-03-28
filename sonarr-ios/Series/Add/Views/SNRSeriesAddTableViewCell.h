//
//  SNRSeriesAddTableViewCell.h
//  sonarr-ios
//
//  Created by Harry Singh on 27/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRSeriesTableViewCell.h"
@class SNRSeries;

@protocol SNRSeriesAddProtocol <NSObject>
@required
-(void)didTapAddSeries:(SNRSeries *)series;

@end

@interface SNRSeriesAddTableViewCell : SNRSeriesTableViewCell
@property (weak, nonatomic) id<SNRSeriesAddProtocol> delegate;

@end
