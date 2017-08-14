//
//  UIImage+Utility.m
//  Sonarr
//
//  Created by Harry Singh on 13/08/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "UIImage+Utility.h"

@implementation UIImage (Utility)

-(CGFloat)ratio{
    return MIN(self.size.height, self.size.width) / MAX(self.size.height, self.size.width);
}

@end
