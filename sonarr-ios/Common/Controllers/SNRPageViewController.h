//
//  SNRPageViewController.h
//  Sonarr
//
//  Created by Harry Singh on 17/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNRPageViewController;

@protocol SNRPageViewControllerProtocol
-(void)pageViewController:(SNRPageViewController *)controller didScrollToIndex:(NSInteger)index;
@end

@interface SNRPageViewController : UIPageViewController
@property (assign, nonatomic) id<SNRPageViewControllerProtocol> sDelegate;

-(void)setTabViewControllers:(NSArray<UIViewController *> *)controllers;
-(void)scrollToViewController:(UIViewController *)controller;
@end
