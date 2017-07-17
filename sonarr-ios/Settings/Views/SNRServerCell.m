//
//  SNRServerCell.m
//  Sonarr
//
//  Created by Harry Singh on 16/07/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRServerCell.h"
#import "UIColor+App.h"

@interface SNRServerCell()
@property (weak, nonatomic) IBOutlet UIView *radioButtonView;

@end
@implementation SNRServerCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path addArcWithCenter:CGPointMake(25, 25) radius:25/2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        path.lineWidth = 2;
        
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.path = path.CGPath;
        shapeLayer.fillColor = [UIColor blackColor].CGColor;
        shapeLayer.strokeColor = [UIColor primary].CGColor;
        shapeLayer.lineWidth = 2;
        shapeLayer.contentsScale = [[UIScreen mainScreen] scale];
        
        [self.radioButtonView.layer addSublayer:shapeLayer];

        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = 0.5;
        animation.fromValue = @(0);
        animation.byValue = @(1);

        dispatch_async(dispatch_get_main_queue(), ^{
            [shapeLayer addAnimation:animation forKey:@"drawLineAnimation"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIBezierPath *path1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(20, 20, 10, 10)];
//                [path addArcWithCenter:CGPointMake(25, 25) radius:20/2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
                
                CAShapeLayer *shapeLayer1 = [[CAShapeLayer alloc] init];
                shapeLayer.path = path1.CGPath;
                shapeLayer.fillColor = [UIColor primary].CGColor;
                shapeLayer.contentsScale = [[UIScreen mainScreen] scale];
                
                [shapeLayer addSublayer:shapeLayer1];
            });
        });
    });
}
@end
