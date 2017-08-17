//
//  SNRRootFolder.h
//  sonarr-ios
//
//  Created by Harry Singh on 27/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SNRRootFolder : JSONModel
+(NSString *)endpoint;

@property (copy, nonatomic) NSString<Optional> *path;
@property (strong, nonatomic) NSNumber<Optional> *freeSpace;
@property (copy, nonatomic) NSArray<Optional> *unmappedFolders;
@property (strong, nonatomic) NSNumber *id;
@end
