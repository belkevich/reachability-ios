//
//  SCNetworkReachability.m
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 9/3/12.
//  Copyright (c) 2012 ClockworkIdeas. All rights reserved.
//

#import "SCNetworkReachability.h"

#define SC_EXCEPTION_HOST_NAME      @"SCNetworkReachability host name is empty"
#define SC_DOMAIN_GET_FLAGS         @"SCNetworkReachability can't determine reachability flags"
#define SC_CODE_GET_FLAGS           501
#define SC_DOMAIN_REF               @"SCNetworkReachability can't create reachability ref"
#define SC_CODE_REF                 502

@interface SCNetworkReachability ()
- (void)checkReachabilityFlags;
- (void)parseReachabilityFlags:(SCNetworkReachabilityFlags)flags;
@end

@implementation SCNetworkReachability

@synthesize isReachable, device, error;

#pragma mark -
#pragma mark main routine

- (id)initWithHostName:(NSString *)hostName
{
    if (hostName.length == 0)
    {
        @throw [NSException exceptionWithName:SC_EXCEPTION_HOST_NAME reason:SC_EXCEPTION_HOST_NAME
                                     userInfo:nil];
    }
    self = [super init];
    if (self)
    {
        reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
        [self checkReachabilityFlags];
    }
    return self;
}

- (id)initWithHostAddress:(const struct sockaddr_in *)hostAddress
{
    self = [super init];
    if (self)
    {
        const struct sockaddr *castedAddress = (const struct sockaddr *)hostAddress;
        reachabilityRef = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, castedAddress);
        [self checkReachabilityFlags];
    }
    return self;
}

- (id)initForLocalWiFi
{
    struct sockaddr_in localWifiAddress;
	bzero(&localWifiAddress, sizeof(localWifiAddress));
	localWifiAddress.sin_len = sizeof(localWifiAddress);
	localWifiAddress.sin_family = AF_INET;
	localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    return [self initWithHostAddress:&localWifiAddress];
}

- (void)dealloc
{
    CFRelease(reachabilityRef);
    [error release];
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
#pragma mark private

- (void)checkReachabilityFlags
{
    if (reachabilityRef)
    {
        SCNetworkReachabilityFlags flags;
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
#endif
            [self parseReachabilityFlags:flags];
        }
        else
        {
            [error release];
            error = [[NSError alloc] initWithDomain:SC_DOMAIN_GET_FLAGS code:SC_CODE_GET_FLAGS
                                           userInfo:nil];
        }
    }
    else
    {
        [error release];
        error = [[NSError alloc] initWithDomain:SC_DOMAIN_REF code:SC_CODE_REF userInfo:nil];
    }
}

- (void)parseReachabilityFlags:(SCNetworkReachabilityFlags)flags
{
    isReachable = (flags & kSCNetworkReachabilityFlagsReachable);
    if (isReachable)
    {
        device = (flags & kSCNetworkReachabilityFlagsIsWWAN) ?
        SCNetworkDeviceCellular : SCNetworkDeviceWiFi;
    }
    else
    {
        device = SCNetworkDeviceNone;
    }
}

@end
