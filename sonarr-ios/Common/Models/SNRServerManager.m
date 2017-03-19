//
//  SNRServerManager.m
//  sonarr-ios
//
//  Created by Harry Singh on 18/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRServerManager.h"

NSString * const SNR_SERVER_MANAGER_DIR = @"sonarr/manager/server";

@interface SNRServerManager()
@property (strong, nonatomic) NSArray *servers;
@end

@implementation SNRServerManager

#pragma mark - Life Cycle

+(instancetype)manager{
    static SNRServerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self init];
    });
    return manager;
}

-(instancetype)init{
    self = [super init];
    if(self){
        [self unarchiveServers];
    }
    return self;
}

-(void)dealloc{
    [self archiveServers];
}

#pragma mark - Encoding / Decoding

-(void)unarchiveServers{
    NSData *notesData = [[NSUserDefaults standardUserDefaults] objectForKey:SNR_SERVER_MANAGER_DIR];
    self.servers = [NSKeyedUnarchiver unarchiveObjectWithData:notesData];
}

-(void)archiveServers{
    NSData *serverData = [NSKeyedArchiver archivedDataWithRootObject:self.servers];
    [[NSUserDefaults standardUserDefaults] setObject:serverData forKey:SNR_SERVER_MANAGER_DIR];
}

#pragma mark - Protocol

@end
