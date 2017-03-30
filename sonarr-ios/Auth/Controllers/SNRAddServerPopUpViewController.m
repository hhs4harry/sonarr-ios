//
//  SNRAddServerPopUpViewController.m
//  sonarr-ios
//
//  Created by Harry Singh on 28/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRAddServerPopUpViewController.h"
#import "SNRServer.h"
#import "SNRServerConfig.h"
#import "SNRServerManager.h"

@interface SNRAddServerPopUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *apiKeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UISwitch *sslSwitch;

@end

@implementation SNRAddServerPopUpViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.ipTextField becomeFirstResponder];
}

- (IBAction)addTouchUpInside:(id)sender {
    SNRServerConfig *config = [[SNRServerConfig alloc] init];
    config.hostname         = self.ipTextField.text;
    config.username         = self.usernameTextField.text;
    config.password         = self.passwordTextField.text;
    config.apiKey           = self.apiKeyTextField.text;
    config.port             = @(self.portTextField.text.integerValue);
    config.SSL              = self.sslSwitch.on;
    
    SNRServer *server = [[SNRServer alloc] initWithConfig:config];
    
    [self showSpinner:YES];
    
    __weak typeof(self) wself = self;
    [server validateServerWithCompletion:^(SNRStatus *status, NSError *error) {
        [wself showSpinner:NO];

        if(status){
            [[SNRServerManager manager] addServer:server];
            [wself dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        [wself showMessage:error.localizedFailureReason ? : error.localizedDescription
                 withTitle:@"Error"];
    }];
}

@end
