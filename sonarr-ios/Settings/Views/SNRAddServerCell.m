//
//  SNRAddServerCell.m
//  Sonarr
//
//  Created by Harry Singh on 16/07/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRAddServerCell.h"
#import "NSString+check.h"
#import "SNRServerConfig.h"
#import "SNRActivityIndicatorView.h"

@interface SNRAddServerCell()
@property (weak, nonatomic) IBOutlet UILabel *addServerLabel;
@property (weak, nonatomic) IBOutlet UITextField *ipTextfield;
@property (weak, nonatomic) IBOutlet UITextField *apiTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UISwitch *sslSwitch;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (assign, nonatomic) BOOL open;
@end

@implementation SNRAddServerCell

- (IBAction)rightButtonTouchUpInside:(id)sender {
    [self endEditing:YES];
    
    if(![self validateInput]) {
        return;
    }
    
    SNRServerConfig *config = [[SNRServerConfig alloc] initWithHostname:self.ipTextfield.text apiKey:self.apiTextField.text port:@(self.portTextField.text.integerValue) andSSL:self.sslSwitch.on];
    
    [SNRActivityIndicatorView showOnTint:YES onView:self];
    
    __weak typeof(self) wself = self;
    [self.delegate addServerWithConfig:config andCompletion:^(SNRStatus *status, NSError *error) {
        if (status) {
            wself.open = NO;
            [wself.delegate expanded:wself.open cell:wself];
            [wself resetInput];
        } else {
#warning - TODO: Handle Error
        }
        [SNRActivityIndicatorView show:NO onView:wself];
    }];
}

-(void)setOpen:(BOOL)open {
    _open = open;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.rightButton.hidden = !open;
        self.leftButton.transform = open ? CGAffineTransformMakeRotation(M_PI_4) : CGAffineTransformIdentity;
    }];
    
    [self.delegate expanded:open cell:self];
}

-(void)setSslSwitch:(UISwitch *)sslSwitch{
    _sslSwitch = sslSwitch;
    
    sslSwitch.transform = CGAffineTransformMakeScale(20 / sslSwitch.frame.size.height, 20 / sslSwitch.frame.size.height);
}
@end
