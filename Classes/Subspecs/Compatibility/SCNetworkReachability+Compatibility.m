//
//  SCNetworkReachability+Compatibility.m
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 4/19/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <SystemConfiguration/SystemConfiguration.h>
#import "SCNetworkReachability+Compatibility.h"
#import "SCReachabilityRefBuilder+Compatibility.h"

@interface SCNetworkReachability (Private)

- (id)initWithReachabilityRef:(SCNetworkReachabilityRef)reachabilityRef;
@end

@implementation SCNetworkReachability (Compatibility)

- (id)initWithHostAddress:(const struct sockaddr_in *)hostAddress
{
    SCNetworkReachabilityRef reachabilityRef = nil;
    reachabilityRef = [SCReachabilityRefBuilder reachabilityRefWithHostAddress:hostAddress];
    return [self initWithReachabilityRef:reachabilityRef];
}

- (id)initForLocalWiFi
{
    SCNetworkReachabilityRef reachabilityRef;
    reachabilityRef = [SCReachabilityRefBuilder reachabilityRefForLocalWiFi];
    return [self initWithReachabilityRef:reachabilityRef];
}

@end
