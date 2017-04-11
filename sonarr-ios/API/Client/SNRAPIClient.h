//
//  SNRAPIClient.h
//  sonarr-ios
//
//  Created by Harry Singh on 13/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import "SNRNetworkProtocol.h"
#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@interface SNRAPIClient : AFHTTPSessionManager <SNRNetworkProtocol>

@end
