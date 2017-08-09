//
//  SNRServerCell.m
//  Sonarr
//
//  Created by Harry Singh on 16/07/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRServerCell.h"
#import "UIColor+App.h"
#import "SNRServer.h"
#import "SNRServerConfig.h"
#import "SNRActivityIndicatorView.h"

@interface SNRServerCell()
@property (weak, nonatomic) IBOutlet UILabel *ipLabel;
@property (weak, nonatomic) IBOutlet UILabel *apiKeyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UITextField *ipTextfield;
@property (weak, nonatomic) IBOutlet UITextField *apiTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UISwitch *sslSwitch;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (assign, nonatomic) BOOL open;
@property (strong, nonatomic) SNRServer *server;
@end

@implementation SNRServerCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
#pragma mark - WIP
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        UIBezierPath *path = [[UIBezierPath alloc] init];
//        [path addArcWithCenter:CGPointMake(25, 25) radius:25/2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
//        path.lineWidth = 2;
//
//        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
//        shapeLayer.path = path.CGPath;
//        shapeLayer.fillColor = [UIColor blackColor].CGColor;
//        shapeLayer.strokeColor = [UIColor primary].CGColor;
//        shapeLayer.lineWidth = 2;
//        shapeLayer.contentsScale = [[UIScreen mainScreen] scale];
//
//        [self.radioButtonView.layer addSublayer:shapeLayer];
//
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//        animation.duration = 0.5;
//        animation.fromValue = @(0);
//        animation.byValue = @(1);
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [shapeLayer addAnimation:animation forKey:@"drawLineAnimation"];
//
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                UIBezierPath *path1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(20, 20, 10, 10)];
////                [path addArcWithCenter:CGPointMake(25, 25) radius:20/2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
//
//                CAShapeLayer *shapeLayer1 = [[CAShapeLayer alloc] init];
//                shapeLayer.path = path1.CGPath;
//                shapeLayer.fillColor = [UIColor primary].CGColor;
//                shapeLayer.contentsScale = [[UIScreen mainScreen] scale];
//
//                [shapeLayer addSublayer:shapeLayer1];
//            });
//        });
//    });
}

-(void)configureWithServer:(SNRServer *)server{
    self.server = server;
    
    self.ipLabel.text = [[self.server.config.hostname stringByAppendingString:@":"] stringByAppendingString:self.server.config.port.stringValue];
    self.apiKeyLabel.text = self.server.config.apiKey;
    
    self.ipTextfield.text = server.config.hostname;
    self.apiTextField.text = server.config.apiKey;
    self.portTextField.text = server.config.port.stringValue;
    self.sslSwitch.on = server.config.SSL;
}

- (IBAction)rightButtonTouchUpInside:(id)sender {
    [self endEditing:YES];
    
    if(![self validateInput]) {
        return;
    }
    
    self.open = !self.open;
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
    
    [UIView animateWithDuration:0.3 animations:^{
        self.rightButton.hidden = !open;
    }];
    
    [self.delegate expanded:open cell:self];
}

-(void)setSslSwitch:(UISwitch *)sslSwitch{
    _sslSwitch = sslSwitch;
    
    sslSwitch.transform = CGAffineTransformMakeScale(20 / sslSwitch.frame.size.height, 20 / sslSwitch.frame.size.height);
}
@end
