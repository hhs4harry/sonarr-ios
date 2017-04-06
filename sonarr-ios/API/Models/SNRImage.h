//
//  SNRImage.h
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@class UIImage;

typedef enum : NSUInteger {
    ImageTypeUnknown = 0,
    ImageTypeFanArt,
    ImageTypeBanner,
    ImageTypePoster,
} ImageType;

@interface SNRImage : JSONModel
@property (copy, nonatomic) NSString *coverType;
@property (copy, nonatomic) NSString *url;

@property (strong, nonatomic) UIImage<Ignore> *image;
@property (readonly) ImageType type;
@end
