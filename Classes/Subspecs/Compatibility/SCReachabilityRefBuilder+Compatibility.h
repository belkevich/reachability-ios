//
//  SCReachabilityRefBuilder+Compatibility.h
//  ReachabilityApp
//
//  Created by Alexey Belkevich on 4/19/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "SCReachabilityRefBuilder.h"
#import <netinet/in.h>

@interface SCReachabilityRefBuilder (Compatibility)

+ (SCNetworkReachabilityRef)reachabilityRefWithHostAddress:(const struct sockaddr_in *)address;
+ (SCNetworkReachabilityRef)reachabilityRefForLocalWiFi;

@end
