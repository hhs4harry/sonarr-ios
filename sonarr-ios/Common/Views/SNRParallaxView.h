//
//  SNRParallaxView.h
//  Sonarr
//
//  Created by Harry Singh on 9/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNRSeries;
@class SNRServer;

@interface SNRParallaxView : UIView
-(void)configureWithSeries:(SNRSeries *)series forServer:(SNRServer *)server;
-(void)animateToDefaultState:(BOOL)animate;
-(void)didPan:(UIPanGestureRecognizer *)urgi;
@end
