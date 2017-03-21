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
@property (strong, nonatomic) NSMutableArray *observers;
@end

@implementation SNRServerManager

#pragma mark - Life Cycle

+(instancetype)manager{
    static SNRServerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
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

#pragma mark - Adding / Removing

-(void)addServer:(SNRServer *)server{
    if(!self.servers){
        self.servers = [[NSMutableArray alloc] init];
    }
    
    [self.servers addObject:server];
    
    if(self.servers.count == 1){
        [self setActiveServer:server];
    }
    
    [self fireDidAddServer:server atIndex:[self.servers indexOfObject:server]];
}

-(void)removeServer:(SNRServer *)server{
    if(!self.servers ||
       ![self.servers containsObject:server]){
        return;
    }
    
    NSInteger serverIndex = [self.servers indexOfObject:server];
    [self.servers removeObjectAtIndex:serverIndex];
    
    [self fireDidRemoveServer:server atIndex:serverIndex];
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

#pragma mark - Delegate

-(void)addObserver:(id<SNRServerManagerProtocol>)observer{
    if([self.observers containsObject:observer]){
        return;
    }
    
    [self.observers addObject:observer];
}

-(void)removeObserver:(id<SNRServerManagerProtocol>)observer{
    if(![self.observers containsObject:observer]){
        return;
    }
    
    [self.observers removeObject:observer];
}

-(void)fireDidAddServer:(SNRServer *)server atIndex:(NSInteger)index{
    for (id<SNRServerManagerProtocol>observer in self.observers) {
        if([observer respondsToSelector:@selector(didAddServer:atIndex:)]){
            [observer didAddServer:server atIndex:index];
        }
    }
    
    [self archiveServers];
}

-(void)fireDidRemoveServer:(SNRServer *)server atIndex:(NSInteger)index{
    for (id<SNRServerManagerProtocol>observer in self.observers) {
        if([observer respondsToSelector:@selector(didDeleteServer:atIndex:)]){
            [observer didDeleteServer:server atIndex:index];
        }
    }
    
    [self archiveServers];
}

-(void)fireDidSetActiveServer:(SNRServer *)server atIndex:(NSInteger)index{
    for (id<SNRServerManagerProtocol>observer in self.observers) {
        if ([observer respondsToSelector:@selector(didSetActiveServer:atIndex:)]) {
            [observer didSetActiveServer:server atIndex:index];
        }
    }
}

-(void)fireDidUnsetActiveServer:(SNRServer *)server atIndex:(NSInteger)index{
    for (id<SNRServerManagerProtocol>observer in self.observers) {
        if([observer respondsToSelector:@selector(didUnsetActiveServer:atIndex:)]){
            [observer didUnsetActiveServer:server atIndex:index];
        }
    }
}

#pragma mark - Getters / Setters

-(NSMutableArray *)observers{
    if(!_observers){
        _observers = [[NSMutableArray alloc] init];
    }
    return _observers;
}

-(void)setActiveServer:(SNRServer *)server{
    if(!server || ![self.servers containsObject:server]){
        return;
    }
    
    NSInteger serverIndex = [self.servers indexOfObject:server];
    NSInteger currServerIndex = NSNotFound;
    
    if(_activeServer){
        currServerIndex = [self.servers indexOfObject:_activeServer];
    }
    
    [self fireDidSetActiveServer:server atIndex:serverIndex];
    [self fireDidUnsetActiveServer:_activeServer atIndex:currServerIndex];
    
    _activeServer = server;
}

@end
