//
//  SCReachabilityRefBuilder.h
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 12/05/13
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface SCReachabilityRefBuilder : NSObject

+ (SCNetworkReachabilityRef)reachabilityRefWithHostName:(NSString *)hostName;

@end
