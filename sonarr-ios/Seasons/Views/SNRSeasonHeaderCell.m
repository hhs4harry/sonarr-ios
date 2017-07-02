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
@property (assign, nonatomic) BOOL expanded;

@end

@implementation SNRSeasonHeaderCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTouchUpInside:)];
    self.gestureRecognizers = @[tap];
}

-(void)cellTouchUpInside:(id)sender{
    [self setExpanded:!self.expanded];
    [self.delegate season:self.season expanded:self.expanded];
}

-(void)setSeason:(SNRSeason *)season{
    _season = season;
    
    if(season.seasonNumber.integerValue == 0){
        self.titleLabel.text = @"Specials";
        return;
    }
    
    self.titleLabel.text = [@"Season " stringByAppendingString:season.seasonNumber.stringValue];
}

-(void)setExpanded:(BOOL)expanded{
    _expanded = expanded;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.chevron.transform = !expanded ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(-M_PI_2);
    }];
}

@end
