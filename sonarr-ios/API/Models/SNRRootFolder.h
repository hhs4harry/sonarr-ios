//
//  SNRRootFolder.h
//  sonarr-ios
//
//  Created by Harry Singh on 27/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SNRRootFolder : JSONModel
@property (copy, nonatomic) NSString *path;
@property (strong, nonatomic) NSNumber *freeSpace;
@property (copy, nonatomic) NSArray *unmappedFolders;
@property (strong, nonatomic) NSNumber *id;
@end
