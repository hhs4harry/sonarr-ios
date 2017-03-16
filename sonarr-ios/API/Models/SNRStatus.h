//
//  SNRStatus.h
//  sonarr-ios
//
//  Created by Harry Singh on 26/02/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SNRStatus : JSONModel
+(NSString *)endpoint;

@property (copy, nonatomic) NSString *version;
@property (copy, nonatomic) NSString *buildTime;
@property (nonatomic) BOOL isDebug;
@property (nonatomic) BOOL isProduction;
@property (nonatomic) BOOL isAdmin;
@property (nonatomic) BOOL isUserInteractive;
@property (copy, nonatomic) NSString *appData;
@property (copy, nonatomic) NSString *osName;
@property (copy, nonatomic) NSString *osVersion;
@property (nonatomic) BOOL isMonoRuntime;
@property (nonatomic) BOOL isLinux;
@property (nonatomic) BOOL isOsx;
@property (nonatomic) BOOL isWindows;
@property (copy, nonatomic) NSString *branch;
@property (copy, nonatomic) NSString *authentication;
@property (copy, nonatomic) NSString *sqliteVersion;
@property (copy, nonatomic) NSString *urlBase;
@property (copy, nonatomic) NSString *runtimeVersion;
@property (copy, nonatomic) NSString *runtimeName;
@end
