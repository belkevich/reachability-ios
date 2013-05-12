//
//  SCReachability.h
//  MyReachability
//
//  Created by Alexey Belkevich on 9/15/12.
//  Copyright (c) 2012 ClockworkIdeas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

@interface SCNetworkReachabilityRefBuilder : NSObject

+ (SCNetworkReachabilityRef)reachabilityRefWithHostName:(NSString *)name;
+ (SCNetworkReachabilityRef)reachabilityRefWithHostAddress:(const struct sockaddr_in *)address;
+ (SCNetworkReachabilityRef)reachabilityRefForLocalWiFi;

@end
