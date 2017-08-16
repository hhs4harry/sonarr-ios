//
//  SNRServerManager.m
//  sonarr-ios
//
//  Created by Harry Singh on 18/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRServerManager.h"
#import "SNRServer.h"

NSString * const SNR_SERVER_MANAGER_DIR = @"sonarr/manager/server";

@interface SNRServerManager() <SNRServerProtocol>
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
    
    server.delegate = self;
    [self.servers addObject:server];
    
    [self fireDidAddServer:server atIndex:[self.servers indexOfObject:server]];
    
    if(self.servers.count == 1){
        [self setActiveServer:server];
    }
}

-(void)removeServer:(SNRServer *)server{
    if(!self.servers ||
       ![self.servers containsObject:server]){
        return;
    }
    
    NSInteger serverIndex = [self.servers indexOfObject:server];
    
    if (self.activeServer == server &&
        self.servers.count == 2) {
        self.activeServer = self.servers[(serverIndex == 0) ? 1 : 0];
    }
    
    [self.servers removeObjectAtIndex:serverIndex];
    
    if (!self.servers || !self.servers.count) {
        _activeServer = nil;
    }
    
    [self fireDidRemoveServer:server atIndex:serverIndex];
}

#pragma mark - Encoding / Decoding

-(void)unarchiveServers{
    NSData *notesData = [[NSUserDefaults standardUserDefaults] objectForKey:SNR_SERVER_MANAGER_DIR];
    self.servers = [NSKeyedUnarchiver unarchiveObjectWithData:notesData];
    
    
    [self.servers enumerateObjectsUsingBlock:^(SNRServer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.active){
            self.activeServer = obj;
        }
        
        obj.delegate = self;
    }];
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

#pragma mark - Server Delegate

-(void)didAddSeries:(NSDictionary<NSNumber *,SNRSeries *> *)series forServer:(SNRServer *)server{
    for(id<SNRServerProtocol>observer in self.observers){
        if([observer respondsToSelector:@selector(didAddSeries:forServer:)]){
            [observer didAddSeries:series forServer:server];
        }
    }
}

-(void)didRemoveSeries:(NSDictionary<NSNumber *,SNRSeries *> *)series forServer:(SNRServer *)server{
    for(id<SNRServerProtocol>observer in self.observers){
        if([observer respondsToSelector:@selector(didRemoveSeries:forServer:)]){
            [observer didRemoveSeries:series forServer:server];
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
    
    _activeServer.active = NO;
    _activeServer = server;
    _activeServer.active = YES;
    
    [self archiveServers];
}

@end
