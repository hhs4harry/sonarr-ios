//
//  SNRPageViewController.h
//  Sonarr
//
//  Created by Harry Singh on 17/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNRPageViewController : UIPageViewController
-(void)setTabViewControllers:(NSArray<UIViewController *> *)controllers;
@end
