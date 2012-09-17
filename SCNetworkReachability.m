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

@interface SCNetworkReachability ()
- (void)checkReachability;
@end

@implementation SCNetworkReachability

@synthesize isReachable, device;

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
    [super dealloc];
}

#pragma mark -
#pragma mark static initialization

+ (SCNetworkReachability *)reachabilityWithHostName:(NSString *)hostName
{
    return [[[SCNetworkReachability alloc] initWithHostName:hostName] autorelease];
}

+ (SCNetworkReachability *)reachabilityWithHostAddress:(const struct sockaddr_in *)hostAddress
{
    return [[[SCNetworkReachability alloc] initWithHostAddress:hostAddress] autorelease];
}

+ (SCNetworkReachability *)reachabilityForLocalWiFi
{
    return [[[SCNetworkReachability alloc] initForLocalWiFi] autorelease];
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
}

#pragma mark -
#pragma mark private

- (void)checkReachability
{
    SCNetworkReachabilityFlagsParser *parser = [SCNetworkReachabilityFlagsParser new];
    if ([parser checkReachabilityRefFlags:reachabilityRef])
    {
        isReachable = [parser isReachable];
        if (isReachable)
        {
            device = [parser isCellular] ? SCNetworkDeviceCellular : SCNetworkDeviceWiFi;
        }
        else
        {
            device = SCNetworkDeviceNone;
        }
    }
    else
    {
        NSError *error = [[[NSError alloc] initWithDomain:SC_ERROR_DOMAIN_GET_FLAGS
                                                     code:SC_ERROR_CODE_GET_FLAGS
                                                 userInfo:nil] autorelease];
        [delegate reachability:self didFail:error];
    }
    [parser release];
}

@end
