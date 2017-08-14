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
@property (weak, nonatomic) IBOutlet UIButton *chevronButton;
@property (weak, nonatomic) IBOutlet UIView *headerBackgroundView;
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

- (IBAction)chevronButtonTouchUpInside:(id)sender {
    [self cellTouchUpInside:sender];
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
    
    [UIView animateWithDuration:0.3 animations:^{
        self.chevronButton.transform = expanded ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(M_PI);
    }];
}

-(void)setChevronButton:(UIButton *)chevronButton{
    _chevronButton = chevronButton;
    
    // Rotate chevron to be the correct way when first loaded.
    self.chevronButton.transform = CGAffineTransformMakeRotation(M_PI);
}

@end
