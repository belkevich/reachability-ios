//
//  SCNetworkReachability.m
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 9/3/12.
//  Copyright (c) 2012 ClockworkIdeas. All rights reserved.
//

#import "SCNetworkReachability.h"
#import "SCNetworkReachabilityScheduler.h"
#import "SCNetworkReachabilityRefBuilder.h"
#import "SCNetworkReachabilityFlagsParser.h"


@interface SCNetworkReachability () <SCNetworkReachabilityDelegate>

@property (nonatomic, assign, readwrite) SCNetworkStatus status;

@end

@implementation SCNetworkReachability

#pragma mark -
#pragma mark main routine

- (id)initWithReachabilityRef:(SCNetworkReachabilityRef)reachabilityRef
{
    self = [self init];
    if (self)
    {
        scheduler = [[SCNetworkReachabilityScheduler alloc] initWithReachabilityRef:reachabilityRef
                                                                           delegate:self];
        SCNetworkReachabilityFlagsParser *parser = [[SCNetworkReachabilityFlagsParser alloc]
                                                     initWithReachabilityRef:reachabilityRef];
        self.status = [parser status];
    }
    return self;
}

- (id)initWithHostName:(NSString *)hostName
{
    SCNetworkReachabilityRef reachabilityRef;
    reachabilityRef = [SCNetworkReachabilityRefBuilder reachabilityRefWithHostName:hostName];
    return [self initWithReachabilityRef:reachabilityRef];
}

- (id)initWithHostAddress:(const struct sockaddr_in *)hostAddress
{
    SCNetworkReachabilityRef reachabilityRef;
    reachabilityRef = [SCNetworkReachabilityRefBuilder reachabilityRefWithHostAddress:hostAddress];
    return [self initWithReachabilityRef:reachabilityRef];
}

- (id)initForLocalWiFi
{
    SCNetworkReachabilityRef reachabilityRef;
    reachabilityRef = [SCNetworkReachabilityRefBuilder reachabilityRefForLocalWiFi];
    return [self initWithReachabilityRef:reachabilityRef];
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
#pragma mark network reachability delegate implementation

- (void)reachabilityDidChange:(SCNetworkStatus)status
{
    self.status = status;
    if (self.delegate)
    {
        [self.delegate reachabilityDidChange:status];
    }
    else if (self.changedBlock)
    {
        self.changedBlock(status);
    }
}

- (void)reachabilityDidFail:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(reachabilityDidFail:)])
    {
        [self.delegate reachabilityDidFail:error];
    }
    else if (self.failedBlock)
    {
        self.failedBlock(error);
    }
}

@end
