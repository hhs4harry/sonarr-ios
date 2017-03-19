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
-(void)didAddServer:(SNRServer *)server atIndex:(NSInteger)index;
-(void)didDeleteServer:(SNRServer *)server atIndex:(NSInteger)index;

@end

@interface SNRServerManager : NSObject
@property (strong, readonly) NSArray *servers;

+(instancetype)manager;

@end
