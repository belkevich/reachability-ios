//
//  SCNetworkReachabilityScheduler.m
//  MyReachability
//
//  Created by Alexey Belkevich on 9/15/12.
//  Copyright (c) 2012 ClockworkIdeas. All rights reserved.
//

#import "SCNetworkReachabilityScheduler.h"
#import "SCNetworkReachabilityFlagsParser.h"

#define SC_SCHEDULER_ERROR_DOMAIN_SCHEDULE  @"SCNetworkReachability: Failed to schedule"
#define SC_SCHEDULER_ERROR_CODE_SCHEDULE    502
#define SC_SCHEDULER_ERROR_DOMAIN_CALLBACK  @"SCNetworkReachability: Failed to set callback"
#define SC_SCHEDULER_ERROR_CODE_CALLBACK    503

static void callbackForReachabilityRef(SCNetworkReachabilityRef target,
                                       SCNetworkReachabilityFlags flags, void *data);

@interface SCNetworkReachabilityScheduler ()

- (void)scheduleReachabilityRef;
- (void)unscheduleReachabilityRef;
- (BOOL)setCallbackForReachabilityRef;
- (void)setRunLoopForReachabilityRef;

@end


@implementation SCNetworkReachabilityScheduler

#pragma mark -
#pragma mark main routine

- (id)initWithReachabilityRef:(SCNetworkReachabilityRef)aRef
                     delegate:(NSObject <SCNetworkReachabilityDelegate> *)aDelegate
{
    self = [super init];
    if (self)
    {
        ref = aRef;
        delegate = aDelegate;
        [self scheduleReachabilityRef];
    }
    return self;
}

- (void)dealloc
{
    [self unscheduleReachabilityRef];
    if (ref)
    {
        CFRelease(ref);
    }
}

#pragma mark -
#pragma mark actions

- (void)scheduleReachabilityRef
{
    if ([self setCallbackForReachabilityRef])
    {
        [self setRunLoopForReachabilityRef];
    }
}

- (void)unscheduleReachabilityRef
{
    if (ref)
    {
        SCNetworkReachabilityUnscheduleFromRunLoop(ref, CFRunLoopGetCurrent(),
                                                   kCFRunLoopDefaultMode);
    }
}

#pragma mark -
#pragma mark private

- (BOOL)setCallbackForReachabilityRef
{
    SCNetworkReachabilityContext context = {0, (__bridge void *)(delegate), NULL, NULL, NULL};
    if (!SCNetworkReachabilitySetCallback(ref, callbackForReachabilityRef, &context))
    {
        NSError *error = [NSError errorWithDomain:SC_SCHEDULER_ERROR_DOMAIN_CALLBACK
                                             code:SC_SCHEDULER_ERROR_CODE_CALLBACK
                                         userInfo:nil];
        [delegate reachabilityDidFail:error];
        return NO;
    }
    return YES;
}

- (void)setRunLoopForReachabilityRef
{
    if (!SCNetworkReachabilityScheduleWithRunLoop(ref, CFRunLoopGetCurrent(),
                                                  kCFRunLoopDefaultMode))
    {
        NSError *error = [NSError errorWithDomain:SC_SCHEDULER_ERROR_DOMAIN_SCHEDULE
                                             code:SC_SCHEDULER_ERROR_CODE_SCHEDULE
                                         userInfo:nil];
        [delegate reachabilityDidFail:error];
    }
}

#pragma mark -
#pragma mark callback

static void callbackForReachabilityRef(SCNetworkReachabilityRef target,
                                       SCNetworkReachabilityFlags flags, void *data)
{
    @autoreleasepool
    {
        NSObject <SCNetworkReachabilityDelegate> *delegate;
        delegate = (__bridge NSObject <SCNetworkReachabilityDelegate> *)data;
        SCNetworkReachabilityFlagsParser *parser = [[SCNetworkReachabilityFlagsParser alloc]
                                                     initWithReachabilityFlags:flags];
        [delegate reachabilityDidChange:[parser status]];
    }
}

@end
