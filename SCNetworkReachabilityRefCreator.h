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

@interface SCNetworkReachabilityRefCreator : NSObject

+ (SCNetworkReachabilityRef)newReachabilityRefWithHostName:(NSString *)name;
+ (SCNetworkReachabilityRef)newReachabilityRefWithHostAddress:(const struct sockaddr_in *)address;
+ (SCNetworkReachabilityRef)newReachabilityRefForLocalWiFi;

@end
