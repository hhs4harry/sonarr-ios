//
//  SNRImage.m
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRImage.h"

@implementation SNRImage

-(NSString *)url{
    if([_url containsString:@"?"]){
        return [[_url componentsSeparatedByString:@"?"] firstObject];
    }
    return _url;
}

@end
