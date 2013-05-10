//
//  SCReachability.m
//  MyReachability
//
//  Created by Alexey Belkevich on 9/15/12.
//  Copyright (c) 2012 ClockworkIdeas. All rights reserved.
//

#import "SCNetworkReachabilityRefCreator.h"

#define SC_CREATOR_EXCEPTION_HOST_NAME          @"SCNetworkReachabilityRefCreator: host name is empty"

@implementation SCNetworkReachabilityRefCreator

#pragma mark -
#pragma mark main routine

+ (SCNetworkReachabilityRef)newReachabilityRefWithHostName:(NSString *)name
{
    if (name.length > 0)
    {
        return SCNetworkReachabilityCreateWithName(NULL, [name UTF8String]);
    }
    @throw [NSException exceptionWithName:SC_CREATOR_EXCEPTION_HOST_NAME
                                   reason:SC_CREATOR_EXCEPTION_HOST_NAME
                                 userInfo:nil];
}

+ (SCNetworkReachabilityRef)newReachabilityRefWithHostAddress:(const struct sockaddr_in *)address
{
    const struct sockaddr *castedAddress = (const struct sockaddr *)address;
    return SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, castedAddress);
}

+ (SCNetworkReachabilityRef)newReachabilityRefForLocalWiFi
{
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len = sizeof(localWifiAddress);
    localWifiAddress.sin_family = AF_INET;
    localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    return [self newReachabilityRefWithHostAddress:&localWifiAddress];
}

@end
