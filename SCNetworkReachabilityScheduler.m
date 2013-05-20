//
//  SCNetworkReachabilityScheduler.m
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 12/05/13
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "SCNetworkReachabilityScheduler.h"
#import "SCNetworkReachabilityFlagsParser.h"


NSString const *kSCNetworkReachabilityChangedNotification = @"SCNetworkReachabilityChanged";

static void callbackForReachabilityRef(SCNetworkReachabilityRef target,
                                       SCNetworkReachabilityFlags flags, void *data);
static void callbackForReachabilityRelease(const void *data);
static const void* callbackForReachabilityRetain(const void *data);


@implementation SCNetworkReachabilityScheduler

#pragma mark -
#pragma mark main routine

- (id)initWithReachabilityRef:(SCNetworkReachabilityRef)aRef
{
    self = [super init];
    if (self)
    {
        ref = aRef;
    }
    return self;
}

- (void)dealloc
{
    if (ref)
    {
        SCNetworkReachabilitySetDispatchQueue(ref, NULL);
        CFRelease(ref);
    }
#if !OS_OBJECT_USE_OBJC
    if (queue)
    {
        dispatch_release(queue);
    }
#endif
}

#pragma mark -
#pragma mark actions

- (BOOL)startReachabilityObserver
{
    SCNetworkReachabilityContext context = {0, NULL, NULL, NULL, NULL};
    context.info = (__bridge void *)self.notificationName;
    context.retain = callbackForReachabilityRetain;
    context.release = callbackForReachabilityRelease;
    BOOL success = SCNetworkReachabilitySetCallback(ref, callbackForReachabilityRef, &context);
    if (success)
    {
        success = SCNetworkReachabilitySetDispatchQueue(ref, [self queue]);
    }
    return success;
}

#pragma mark -
#pragma mark properties

- (dispatch_queue_t)queue
{
    if (!queue)
    {
        NSString *queueName = [NSString stringWithFormat:@"%ld.org.okolodev.reachability",
                               (unsigned long)self.hash];
        queue = dispatch_queue_create([queueName cStringUsingEncoding:NSASCIIStringEncoding], NULL);
    }
    return queue;
}

- (NSString *)notificationName
{
    return [NSString stringWithFormat:@"%@.%ld", kSCNetworkReachabilityChangedNotification,
                     (unsigned long)self.hash];
}

#pragma mark -
#pragma mark callback

static void callbackForReachabilityRef(SCNetworkReachabilityRef __unused target,
                                       SCNetworkReachabilityFlags flags, void *data)
{
    NSString *notificationName = (__bridge NSString *)data;
    SCNetworkReachabilityFlagsParser *parser;
    parser = [[SCNetworkReachabilityFlagsParser alloc] initWithReachabilityFlags:flags];
    NSNumber *number = [[NSNumber alloc] initWithInteger:parser.status];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:number];
}

static void callbackForReachabilityRelease(const void *data)
{
    CFRelease(data);
}

static const void* callbackForReachabilityRetain(const void *data)
{
    NSString *string = (__bridge NSString *)data;
    return CFBridgingRetain(string);
}

@end
