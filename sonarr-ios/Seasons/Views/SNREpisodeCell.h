//
//  SNREpisodeCell.h
//  sonarr-ios
//
//  Created by Harry Singh on 18/06/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNREpisode;

@interface SNREpisodeCell : UITableViewCell
-(void)setEpisode:(SNREpisode *)episode;

@end
