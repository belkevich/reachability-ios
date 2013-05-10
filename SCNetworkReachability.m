//
//  SCNetworkReachability.m
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 9/3/12.
//  Copyright (c) 2012 ClockworkIdeas. All rights reserved.
//

#import "SCNetworkReachability.h"
#import "SCNetworkReachabilityRefCreator.h"
#import "SCNetworkReachabilityFlagsParser.h"
#import "SCNetworkReachabilityScheduler.h"

#define SC_ERROR_DOMAIN_GET_FLAGS   @"SCNetworkReachability: Can't determine reachability flags"
#define SC_ERROR_CODE_GET_FLAGS     501

@implementation SCNetworkReachability

@synthesize status;

#pragma mark -
#pragma mark main routine

- (id)initWithHostName:(NSString *)hostName
{
    self = [super init];
    if (self)
    {
        reachabilityRef = [SCNetworkReachabilityRefCreator newReachabilityRefWithHostName:hostName];
        [self checkReachability];
    }
    return self;
}

- (id)initWithHostAddress:(const struct sockaddr_in *)hostAddress
{
    self = [super init];
    if (self)
    {
        reachabilityRef = [SCNetworkReachabilityRefCreator
                           newReachabilityRefWithHostAddress:hostAddress];
        [self checkReachability];
    }
    return self;
}

- (id)initForLocalWiFi
{
    self = [super init];
    if (self)
    {
        reachabilityRef = [SCNetworkReachabilityRefCreator newReachabilityRefForLocalWiFi];
        [self checkReachability];
    }
    return self;
}

- (void)dealloc
{
    if (delegate)
    {
        [SCNetworkReachabilityScheduler unscheduleReachabilityRef:reachabilityRef];
    }
    CFRelease(reachabilityRef);
}

#pragma mark -
#pragma mark static initialization

+ (SCNetworkReachability *)reachabilityWithHostName:(NSString *)hostName
{
    return [[SCNetworkReachability alloc] initWithHostName:hostName];
}

+ (SCNetworkReachability *)reachabilityWithHostAddress:(const struct sockaddr_in *)hostAddress
{
    return [[SCNetworkReachability alloc] initWithHostAddress:hostAddress];
}

+ (SCNetworkReachability *)reachabilityForLocalWiFi
{
    return [[SCNetworkReachability alloc] initForLocalWiFi];
}

#pragma mark -
#pragma mark actions

- (void)checkReachability
{
    SCNetworkReachabilityFlagsParser *parser = [SCNetworkReachabilityFlagsParser new];
    if ([parser checkReachabilityRefFlags:reachabilityRef])
    {
        if ([parser isReachable])
        {
            status = [parser isCellular] ?
            SCNetworkStatusReachableViaCellular : SCNetworkStatusReachableViaWiFi;
        }
        else
        {
            status = SCNetworkStatusNotReachable;
        }
    }
    else
    {
        NSError *error = [[NSError alloc] initWithDomain:SC_ERROR_DOMAIN_GET_FLAGS
                                                     code:SC_ERROR_CODE_GET_FLAGS
                                                 userInfo:nil];
        [delegate reachability:self didFail:error];
    }
}

#pragma mark -
#pragma mark properties

@dynamic delegate;

- (NSObject <SCNetworkReachabilityDelegate> *)delegate
{
    return delegate;
}

- (void)setDelegate:(NSObject<SCNetworkReachabilityDelegate> *)aDelegate
{
    if (!delegate && aDelegate)
    {
        [SCNetworkReachabilityScheduler scheduleReachability:self withRef:reachabilityRef];
    }
    else if (delegate && !aDelegate)
    {
        [SCNetworkReachabilityScheduler unscheduleReachabilityRef:reachabilityRef];
    }
    delegate = aDelegate;
}

@end
