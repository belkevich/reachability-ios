//
//  SCNetworkReachabilityRefBuilder.m
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 12/05/13
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "SCNetworkReachabilityRefBuilder.h"

#define SC_CREATOR_EXCEPTION_HOST_NAME      @"SCNetworkReachabilityRefCreator: host name is empty"

@implementation SCNetworkReachabilityRefBuilder

#pragma mark -
#pragma mark main routine

+ (SCNetworkReachabilityRef)reachabilityRefWithHostName:(NSString *)name
{
    if (name.length > 0)
    {
        return SCNetworkReachabilityCreateWithName(NULL, [name UTF8String]);
    }
    @throw [NSException exceptionWithName:SC_CREATOR_EXCEPTION_HOST_NAME
                                   reason:SC_CREATOR_EXCEPTION_HOST_NAME
                                 userInfo:nil];
}

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
