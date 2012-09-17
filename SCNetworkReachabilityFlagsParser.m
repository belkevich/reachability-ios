//
//  SCNetworkReachabilityFlagsParser.m
//  MyReachability
//
//  Created by Alexey Belkevich on 9/15/12.
//  Copyright (c) 2012 ClockworkIdeas. All rights reserved.
//

#import "SCNetworkReachabilityFlagsParser.h"

#define SC_FLAGS_PARSER_EXCEPTION_REF   @"SCNetworkReachabilityFlagsParser: reachability ref is empty"

@implementation SCNetworkReachabilityFlagsParser

#pragma mark -
#pragma mark main routine

- (id)initWithReachabilityRef:(SCNetworkReachabilityRef)reachabilityRef
{
    if (!reachabilityRef)
    {
        @throw [NSException exceptionWithName:SC_FLAGS_PARSER_EXCEPTION_REF
                                       reason:SC_FLAGS_PARSER_EXCEPTION_REF
                                     userInfo:nil];
    }
    self = [super init];
    if (self)
    {
        [self checkReachabilityRefFlags:reachabilityRef];
    }
    return self;
}

#pragma mark -
#pragma mark actions

- (BOOL)checkReachabilityRefFlags:(SCNetworkReachabilityRef)reachabilityRef
{
    if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
    {
#ifdef DEBUG
        NSLog(@"Reachability Flag Status: %c%c %c%c%c%c%c%c%c\n",
              (flags & kSCNetworkReachabilityFlagsIsWWAN)				? 'W' : '-',
              (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
              (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
              (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
              (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
              (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
              (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
              (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
              (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-'
              );
        return YES;
#endif
    }
    return NO;
}

- (BOOL)isReachable
{
    return (flags & kSCNetworkReachabilityFlagsReachable);
}

- (BOOL)isCellular
{
    return (flags & kSCNetworkReachabilityFlagsIsWWAN);
}

@end
