//
//  SNRSettingsCell.m
//  Sonarr
//
//  Created by Harry Singh on 28/07/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRSettingsCell.h"
#import "NSString+check.h"
#import "SNRServerConfig.h"
#import "SNRActivityIndicatorView.h"

@interface SNRSettingsCell() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ipTextfield;
@property (weak, nonatomic) IBOutlet UITextField *apiTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UISwitch *sslSwitch;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (assign, nonatomic) BOOL open;
@end

@implementation SNRSettingsCell

- (IBAction)rightButtonTouchUpInside:(id)sender {
    [self endEditing:YES];
    
    if(![self validateInput]) {
        return;
    }
}

- (IBAction)leftButtonTouchUpInside:(id)sender {
    self.open = !self.open;
}

-(BOOL)validateInput{
    if (self.ipTextfield.text.nonEmpty &&
        self.apiTextField.text.nonEmpty &&
        self.portTextField.text.nonEmpty) {
        
        return YES;
    } else {
        if (!self.ipTextfield.text.nonEmpty) {
            [self showError:YES onTextField:self.ipTextfield];
        }
        
        if (!self.apiTextField.text.nonEmpty) {
            [self showError:YES onTextField:self.apiTextField];
        }
        
        if (!self.portTextField.text.nonEmpty) {
            [self showError:YES onTextField:self.portTextField];
        }
    }
    
    return NO;
}

-(void)showError:(BOOL)show onTextField:(UITextField *)textfield{
    NSString *text;
    if (textfield.placeholder.length) {
        text = textfield.placeholder;
    } else {
        text = textfield.attributedPlaceholder.string;
    }
    
    textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName : show ? [[UIColor redColor] colorWithAlphaComponent:0.5] : [[UIColor whiteColor] colorWithAlphaComponent:0.5]}];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.ipTextfield) {
        NSMutableCharacterSet *charSet = [NSMutableCharacterSet alphanumericCharacterSet];
        [charSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
        return ![string stringByTrimmingCharactersInSet:charSet].length;
    } else if (textField == self.apiTextField){
        return ![string stringByTrimmingCharactersInSet:[NSCharacterSet alphanumericCharacterSet]].length;
    } else if (textField == self.portTextField) {
        if(range.length + range.location > textField.text.length){
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if (newLength > 5) {
            return NO;
        } else if ([string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length) {
            return NO;
        }
        
        return !([textField.text stringByReplacingCharactersInRange:range withString:string].integerValue > 65535);
    } else {
        return YES;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self showError:NO onTextField:textField];
}

-(void)resetInput{
    self.ipTextfield.text = @"";
    self.portTextField.text = @"";
    self.apiTextField.text = @"";
    [self.sslSwitch setOn:NO];
}

#pragma mark - Setters

-(void)setIpTextfield:(UITextField *)ipTextfield{
    _ipTextfield = ipTextfield;
    
    [self showError:NO onTextField:ipTextfield];
}

-(void)setApiTextField:(UITextField *)apiTextField{
    _apiTextField = apiTextField;
    
    [self showError:NO onTextField:apiTextField];
}

-(void)setPortTextField:(UITextField *)portTextField{
    _portTextField = portTextField;
    
    [self showError:NO onTextField:portTextField];
}

-(void)setOpen:(BOOL)open {
    _open = open;

    [self.delegate expanded:open cell:self];
}

-(void)setSslSwitch:(UISwitch *)sslSwitch{
    _sslSwitch = sslSwitch;
    
    sslSwitch.transform = CGAffineTransformMakeScale(20 / sslSwitch.frame.size.height, 20 / sslSwitch.frame.size.height);
}
@end
