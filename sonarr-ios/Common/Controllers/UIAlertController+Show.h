//
//  UIAlertController+Show.h
//  photoBadge
//
//  Created by Harry Singh on 5/09/16.
//  Copyright © 2016 MEA Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Show)

+(UIAlertController *)alertWithTitle:(NSString *)title
                             message:(NSString *)message
                          andActions:(NSArray<UIAlertAction *>*)actions;

-(void)show;
-(void)showAnimated:(BOOL)animated;
@end
