//
//  SCReachabilityFlagsParser.m
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 12/05/13
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "SCReachabilityFlagsParser.h"


@implementation SCReachabilityFlagsParser

#pragma mark - public

+ (SCNetworkStatus)statusWithFlags:(SCNetworkReachabilityFlags)flags
{
#ifdef DEBUG
    [self printFlagsToLog:flags];
#endif
    if ([self isReachableWithFlags:flags])
    {
#if TARGET_OS_IPHONE
        return [self isCellularWithFlags:flags] ? SCNetworkStatusReachableViaCellular :
               SCNetworkStatusReachableViaWiFi;
#else
        return SCNetworkStatusReachable;
#endif
    }
    else
    {
        return SCNetworkStatusNotReachable;
    }
}

#pragma mark - private

+ (BOOL)isReachableWithFlags:(SCNetworkConnectionFlags)flags
{
    return (flags & kSCNetworkReachabilityFlagsReachable) != 0;
}

#if TARGET_OS_IPHONE
+ (BOOL)isCellularWithFlags:(SCNetworkReachabilityFlags)flags
{
    return (flags & kSCNetworkReachabilityFlagsIsWWAN) != 0;
}
#endif

+ (void)printFlagsToLog:(SCNetworkReachabilityFlags)flags
{
    NSLog(@"Reachability Flag Status: %c%c %c%c%c%c%c%c%c\n",
#if TARGET_OS_IPHONE
          (flags & kSCNetworkReachabilityFlagsIsWWAN) ? 'W' : '-',
#else
              '-',
#endif
          (flags & kSCNetworkReachabilityFlagsReachable) ? 'R' : '-',
          (flags & kSCNetworkReachabilityFlagsTransientConnection) ? 't' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionRequired) ? 'c' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) ? 'C' : '-',
          (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnDemand) ? 'D' : '-',
          (flags & kSCNetworkReachabilityFlagsIsLocalAddress) ? 'l' : '-',
          (flags & kSCNetworkReachabilityFlagsIsDirect) ? 'd' : '-'
         );
}

@end
