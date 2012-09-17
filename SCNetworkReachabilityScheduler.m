//
//  SCNetworkReachabilityScheduler.m
//  MyReachability
//
//  Created by Alexey Belkevich on 9/15/12.
//  Copyright (c) 2012 ClockworkIdeas. All rights reserved.
//

#import "SCNetworkReachabilityScheduler.h"
#import "SCNetworkReachability.h"

#define SC_SCHEDULER_ERROR_DOMAIN_SCHEDULE  @"SCNetworkReachability: Failed to schedule"
#define SC_SCHEDULER_ERROR_CODE_SCHEDULE    502
#define SC_SCHEDULER_ERROR_DOMAIN_CALLBACK  @"SCNetworkReachability: Failed to set callback"
#define SC_SCHEDULER_ERROR_CODE_CALLBACK    503
#define SC_SCHEDULER_EXCEPTION_CALLBACK     @"SCNetworkReachabilityScheduler: received data is not \
SCNetworkReachability instance"

@interface SCNetworkReachabilityScheduler ()
+ (BOOL)setCallbackForReachability:(SCNetworkReachability *)reachability
                           withRef:(SCNetworkReachabilityRef)ref;
+ (void)scheduleInRunLoopReachability:(SCNetworkReachability *)reachability
                              withRef:(SCNetworkReachabilityRef)ref;
// callback
static void callback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *data);
@end

@implementation SCNetworkReachabilityScheduler

#pragma mark -
#pragma mark actions

+ (void)scheduleReachability:(SCNetworkReachability *)reachability
                     withRef:(SCNetworkReachabilityRef)ref
{
    if ([self setCallbackForReachability:reachability withRef:ref])
    {
        [self scheduleInRunLoopReachability:reachability withRef:ref];
    }
}

+ (void)unscheduleReachabilityRef:(SCNetworkReachabilityRef)ref
{
    if (ref)
    {
        SCNetworkReachabilityUnscheduleFromRunLoop(ref, CFRunLoopGetCurrent(),
                                                   kCFRunLoopDefaultMode);
    }
}

#pragma mark -
#pragma mark private

+ (BOOL)setCallbackForReachability:(SCNetworkReachability *)reachability
                           withRef:(SCNetworkReachabilityRef)ref
{
    SCNetworkReachabilityContext context = {0, reachability, NULL, NULL, NULL};
	if(!SCNetworkReachabilitySetCallback(ref, callback, &context))
	{
        NSError *error = [NSError errorWithDomain:SC_SCHEDULER_ERROR_DOMAIN_CALLBACK
                                             code:SC_SCHEDULER_ERROR_CODE_CALLBACK
                                         userInfo:nil];
        [reachability.delegate reachability:reachability didFail:error];
        return NO;
	}
    return YES;
}

+ (void)scheduleInRunLoopReachability:(SCNetworkReachability *)reachability
                              withRef:(SCNetworkReachabilityRef)ref
{
    if(!SCNetworkReachabilityScheduleWithRunLoop(ref, CFRunLoopGetCurrent(),
                                                 kCFRunLoopDefaultMode))
    {
        NSError *error = [NSError errorWithDomain:SC_SCHEDULER_ERROR_DOMAIN_SCHEDULE
                                             code:SC_SCHEDULER_ERROR_CODE_SCHEDULE
                                         userInfo:nil];
        [reachability.delegate reachability:reachability didFail:error];
    }
}

#pragma mark -
#pragma mark callback

static void callback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *data)
{
    NSObject *dataObject = (NSObject *)data;
    if ([dataObject isKindOfClass:[SCNetworkReachability class]])
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        SCNetworkReachability *reachability = (SCNetworkReachability *)dataObject;
        [reachability.delegate reachabilityDidChange:reachability];
        [pool drain];
    }
    else
    {
        @throw [NSException exceptionWithName:SC_SCHEDULER_EXCEPTION_CALLBACK
                                       reason:SC_SCHEDULER_EXCEPTION_CALLBACK
                                     userInfo:nil];
    }
}

@end
