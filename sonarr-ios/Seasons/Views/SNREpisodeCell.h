//
//  SNREpisodeCell.h
//  sonarr-ios
//
//  Created by Harry Singh on 18/06/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNREpisode;

@protocol SNREpisodeCellProtocol
-(void)automaticSearchForEpisode:(SNREpisode *)episode;
-(void)manualSearchForEpisode:(SNREpisode *)episode;

@end

@interface SNREpisodeCell : UITableViewCell
@property (weak, nonatomic) id<SNREpisodeCellProtocol> delegate;

-(void)setEpisode:(SNREpisode *)episode;
@end
