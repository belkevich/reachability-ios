//
//  SCNetworkReachabilityRefBuilder.h
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 12/05/13
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

@interface SCNetworkReachabilityRefBuilder : NSObject

+ (SCNetworkReachabilityRef)reachabilityRefWithHostName:(NSString *)name;
+ (SCNetworkReachabilityRef)reachabilityRefWithHostAddress:(const struct sockaddr_in *)address;
+ (SCNetworkReachabilityRef)reachabilityRefForLocalWiFi;

@end
