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
@property (assign, nonatomic) NSInteger currIndex;
@end

@implementation SNRPageViewController

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.delegate = self;
    self.dataSource = self;
}

-(void)setTabViewControllers:(NSArray<UIViewController *> *)controllers{
    self.currIndex = 0;
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

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    self.currIndex = [self.controllers indexOfObject:previousViewControllers.firstObject];
    self.currIndex = self.controllers.count - 1 - self.currIndex;
}

-(void)scrollToViewController:(UIViewController *)controller{
    [self setViewControllers:@[controller] direction:[self.controllers indexOfObject:controller] > self.currIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    self.currIndex = [self.controllers indexOfObject:controller];
}

-(void)setCurrIndex:(NSInteger)currIndex{
    _currIndex = currIndex;
    
    if (self.sDelegate && [(NSObject *)self.sDelegate respondsToSelector:@selector(pageViewController:didScrollToIndex:)]) {
        [self.sDelegate pageViewController:self didScrollToIndex:currIndex];
    }
}

@end
