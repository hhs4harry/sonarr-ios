//
//  SNRPageViewController.m
//  Sonarr
//
//  Created by Harry Singh on 17/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRPageViewController.h"

@interface SNRPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (strong, nonatomic) NSArray<UIViewController *> *controllers;
@end

@implementation SNRPageViewController

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.delegate = self;
    self.dataSource = self;
}

-(void)setTabViewControllers:(NSArray<UIViewController *> *)controllers{
    self.controllers = controllers;
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerAfterViewController:(nonnull UIViewController *)viewController {
    NSInteger index = [self.controllers indexOfObject:viewController];
    
    if(index == self.controllers.count-1){
        return nil;
    }
    
    return [self.controllers objectAtIndex:index+1];
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController {
    NSInteger index = [self.controllers indexOfObject:viewController];
    
    if (index == 0) {
        return nil;
    }
    
    return [self.controllers objectAtIndex:index-1];
}

@end
