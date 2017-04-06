//
//  SNRImageView.m
//  sonarr-ios
//
//  Created by Harry Singh on 21/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRImageView.h"
#import "UIImage+Remote.h"
#import "SNRActivityIndicatorView.h"

@interface SNRImageView()
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@end

@implementation SNRImageView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.allowsEdgeAntialiasing = YES;
}

-(void)setImage:(UIImage *)image{
    [super setImage:image];
    
    [SNRActivityIndicatorView show:NO onView:self];
}

-(void)setImageWithURL:(NSURL *)url{
    [self setImageWithURL:url forClient:nil andCompletion:nil];
}

-(void)setImageWithURL:(NSURL *)url forClient:(SNRAPIClient *)client andCompletion:(void(^)(UIImage *image))completion{
    NSInteger tag = self.tag + 1;
    self.tag = tag;
    
    [SNRActivityIndicatorView show:YES onView:self];
    
    __weak typeof(self) wself = self;
    
    __block void(^finishUp)(UIImage *image) = ^(UIImage *image){
        if(tag == self.tag){
            if(image){
                __strong typeof(wself) sself = wself;
                sself.image = image;
            }
        }
        
        if(completion){
            completion(image);
        }
    };
    
    if(client){
        [UIImage imageWithURL:url forClient:client andCompletion:^(UIImage *image) {
            finishUp(image);
        }];
    }else{
        [UIImage imageWithURL:url andCompletion:^(UIImage *image) {
            finishUp(image);
        }];
    }
}

//- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
//    CGFloat ratio = MIN(image.size.width, image.size.height) / MAX(image.size.width, image.size.height);
//    CGFloat a = MAX(size.width, size.height);
//    CGFloat b = ratio * a;
//    
//    if(size.width > size.height){
//        size = CGSizeMake(a * 2, b * 2);
//    }else{
//        size = CGSizeMake(b * 2, a * 2);
//    }
//    
//    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
//    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationHigh);
//    CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), YES);
//    CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), YES);
//    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    
//    CGAffineTransformMakeScale(a / MAX(image.size.width, image.size.height), a / MAX(image.size.width, image.size.height));
//
//    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return destImage;
//}
@end
