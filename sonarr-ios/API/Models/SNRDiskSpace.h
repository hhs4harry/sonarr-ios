//
//  SNRDiskSpace.h
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SNRDiskSpace : JSONModel
@property (copy, nonatomic) NSString *path;
@property (copy, nonatomic) NSString<Optional> *label;
@property (strong, nonatomic) NSNumber *freeSpace;
@property (strong, nonatomic) NSNumber *totalSpace;
@end
