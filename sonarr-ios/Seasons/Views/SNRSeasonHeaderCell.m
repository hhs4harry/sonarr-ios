//
//  SNRSeasonHeaderCell.m
//  sonarr-ios
//
//  Created by Harry Singh on 16/06/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRSeasonHeaderCell.h"

@interface SNRSeasonHeaderCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chevron;
@property (strong, nonatomic) SNRSeason *season;

@end

@implementation SNRSeasonHeaderCell

-(void)setSeason:(SNRSeason *)season{
    _season = season;
    
    if(season.seasonNumber.integerValue == 0){
        self.titleLabel.text = @"Specials";
        return;
    }
    
    self.titleLabel.text = [@"Season " stringByAppendingString:season.seasonNumber.stringValue];
}

@end
