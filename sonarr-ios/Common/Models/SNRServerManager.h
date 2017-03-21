//
//  SNRServerManager.h
//  sonarr-ios
//
//  Created by Harry Singh on 18/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SNRServer;

@protocol SNRServerManagerProtocol <NSObject>
@optional
-(void)didAddServer:(SNRServer *)server atIndex:(NSInteger)index;
-(void)didDeleteServer:(SNRServer *)server atIndex:(NSInteger)index;
-(void)didSetActiveServer:(SNRServer *)server atIndex:(NSInteger)index;
-(void)didUnsetActiveServer:(SNRServer *)server atIndex:(NSInteger)integer;
@end

@interface SNRServerManager : NSObject
@property (strong, readonly) SNRServer *activeServer;
@property (strong, nonatomic) NSMutableArray *servers;

+(instancetype)manager;
-(void)addServer:(SNRServer *)server;
-(void)removeServer:(SNRServer *)server;

-(void)addObserver:(id<SNRServerManagerProtocol>)observer;
-(void)removeObserver:(id<SNRServerManagerProtocol>)observer;

-(void)setActiveServer:(SNRServer *)server;
@end
