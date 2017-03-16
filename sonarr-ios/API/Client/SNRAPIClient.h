//
//  SNRAPIClient.h
//  sonarr-ios
//
//  Created by Harry Singh on 13/03/17.
//  Copyright © 2017 Harry Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNRNetworkProtocol.h"

//#if AF3

#import <AFNetworking/AFHTTPSessionManager.h>
@interface SNRAPIClient : AFHTTPSessionManager <SNRNetworkProtocol>

@end
//#endif
