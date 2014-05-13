//
//  SCReachabilityFlagsParser.h
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 12/05/13
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "SCNetworkStatus.h"

@interface SCReachabilityFlagsParser : NSObject

+ (SCNetworkStatus)statusWithFlags:(SCNetworkReachabilityFlags)flags;

@end
