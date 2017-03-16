//
//  SNRData.h
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SNRData : JSONModel
@property (copy, nonatomic) NSString<Optional> *downloadClient;
@property (copy, nonatomic) NSString<Optional> *droppedPath;
@property (copy, nonatomic) NSString<Optional> *importedPath;
@end
