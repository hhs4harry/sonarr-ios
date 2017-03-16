//
//  SNRImage.h
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SNRImage : JSONModel
@property (copy, nonatomic) NSString *coverType;
@property (copy, nonatomic) NSString *url;
@end
