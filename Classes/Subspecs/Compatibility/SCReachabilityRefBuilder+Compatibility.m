//
//  SCReachabilityRefBuilder+Compatibility.m
//  ReachabilityApp
//
//  Created by Alexey Belkevich on 4/19/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "SCReachabilityRefBuilder+Compatibility.h"

@implementation SCReachabilityRefBuilder (Compatibility)

+ (SCNetworkReachabilityRef)reachabilityRefWithHostAddress:(const struct sockaddr_in *)address
{
    const struct sockaddr *castedAddress = (const struct sockaddr *)address;
    return SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, castedAddress);
}

+ (SCNetworkReachabilityRef)reachabilityRefForLocalWiFi
{
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len = (__uint8_t)sizeof(localWifiAddress);
    localWifiAddress.sin_family = AF_INET;
    localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    return [self reachabilityRefWithHostAddress:&localWifiAddress];
}

@end
