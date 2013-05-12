//
//  SCNetworkReachabilityFlagsParser.m
//  MyReachability
//
//  Created by Alexey Belkevich on 9/15/12.
//  Copyright (c) 2012 ClockworkIdeas. All rights reserved.
//

#import "SCNetworkReachabilityFlagsParser.h"

@interface SCNetworkReachabilityFlagsParser ()

- (BOOL)isReachable;
- (BOOL)isCellular;

@end

@implementation SCNetworkReachabilityFlagsParser

#pragma mark -
#pragma mark main routine

- (id)initWithReachabilityFlags:(SCNetworkReachabilityFlags)aFlags
{
    self = [super init];
    if (self)
    {
        flags = aFlags;
#ifdef DEBUG
        NSLog(@"Reachability Flag Status: %c%c %c%c%c%c%c%c%c\n",
              (flags & kSCNetworkReachabilityFlagsIsWWAN) ? 'W' : '-',
              (flags & kSCNetworkReachabilityFlagsReachable) ? 'R' : '-',
              (flags & kSCNetworkReachabilityFlagsTransientConnection) ? 't' : '-',
              (flags & kSCNetworkReachabilityFlagsConnectionRequired) ? 'c' : '-',
              (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) ? 'C' : '-',
              (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
              (flags & kSCNetworkReachabilityFlagsConnectionOnDemand) ? 'D' : '-',
              (flags & kSCNetworkReachabilityFlagsIsLocalAddress) ? 'l' : '-',
              (flags & kSCNetworkReachabilityFlagsIsDirect) ? 'd' : '-');
#endif
    }
    return self;
}


- (id)initWithReachabilityRef:(SCNetworkReachabilityRef)reachabilityRef
{
    SCNetworkReachabilityFlags aFlags;
    SCNetworkReachabilityGetFlags(reachabilityRef, &aFlags);
    return [self initWithReachabilityFlags:aFlags];
}

#pragma mark -
#pragma mark actions

- (SCNetworkStatus)status
{
    if ([self isReachable])
    {
        return [self isCellular] ? SCNetworkStatusReachableViaCellular :
               SCNetworkStatusReachableViaWiFi;
    }
    else
    {
        return SCNetworkStatusNotReachable;
    }
}

#pragma mark -
#pragma mark private

- (BOOL)isReachable
{
    return (flags & kSCNetworkReachabilityFlagsReachable) != 0;
}

- (BOOL)isCellular
{
    return (flags & kSCNetworkReachabilityFlagsIsWWAN) != 0;
}

@end
