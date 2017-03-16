//
//  SNRBaseViewController.m
//  sonarr-ios
//
//  Created by Harry Singh on 12/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRBaseViewController.h"

@interface SNRBaseViewController ()

@end

@implementation SNRBaseViewController

+(UIStoryboard *)vcStoryboard{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+(NSString *)storyboardIdentifier{
    return [NSStringFromClass([self class]) stringByAppendingString:@"SBID"];
}

@end
