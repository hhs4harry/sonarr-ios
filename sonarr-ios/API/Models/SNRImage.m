//
//  SNRImage.m
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRImage.h"

@interface SNRImage()
@property (assign, nonatomic) ImageType type;
@end

@implementation SNRImage

+(BOOL)propertyIsIgnored:(NSString *)propertyName{
    if([propertyName isEqualToString:@"type"]){
        return YES;
    }
    
    return [super propertyIsIgnored:propertyName];
}

-(ImageType)type{
    if(_type){
        return _type;
    }
    
    if(!self.coverType || !self.coverType.length){
        _type = ImageTypeUnknown;
    }else if([self.coverType.lowercaseString isEqualToString:@"fanart"]){
        _type = ImageTypeFanArt;
    }else if ([self.coverType.lowercaseString isEqualToString:@"banner"]){
        _type = ImageTypeBanner;
    }else if([self.coverType.lowercaseString isEqualToString:@"poster"]){
        _type = ImageTypePoster;
    }else{
        _type = ImageTypeUnknown;
    }
    
    return _type;
}

@end
