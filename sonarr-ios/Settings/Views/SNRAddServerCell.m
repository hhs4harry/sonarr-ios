//
//  SNRAddServerCell.m
//  Sonarr
//
//  Created by Harry Singh on 16/07/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRAddServerCell.h"

@interface SNRAddServerCell()
@property (weak, nonatomic) IBOutlet UITextField *ipTextfield;
@property (weak, nonatomic) IBOutlet UITextField *apiTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UISwitch *sslSwitch;
@property (weak, nonatomic) IBOutlet UIButton *tickButton;
@property (weak, nonatomic) IBOutlet UIButton *adServerButton;
@property (assign, nonatomic) BOOL open;
@end

@implementation SNRAddServerCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.open = NO;
}

- (IBAction)addServerButtonTouchUpInside:(id)sender {
    self.open = !self.open;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tickButton.hidden = !self.open;
        self.adServerButton.transform = self.open ? CGAffineTransformMakeRotation(M_PI_4) : CGAffineTransformIdentity;
    }];

    [self.delegate expand:self.open cell:self];
}

-(void)setSslSwitch:(UISwitch *)sslSwitch{
    _sslSwitch = sslSwitch;
    
    sslSwitch.transform = CGAffineTransformMakeScale(0.6774193548, 0.6774193548);
}

@end
