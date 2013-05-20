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

@interface SCNetworkReachabilityScheduler ()

@property (nonatomic, weak, readonly) dispatch_queue_t queue;

@end

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
}

#pragma mark -
#pragma mark actions

- (BOOL)startReachabilityObserver
{
    BOOL success = SCNetworkReachabilitySetDispatchQueue(ref, self.queue);
    if (success)
    {
        NSString *name = self.notificationName;
        SCNetworkReachabilityContext context = {0, (__bridge void *)name, NULL, NULL, NULL};
        success = SCNetworkReachabilitySetCallback(ref, callbackForReachabilityRef, &context);
    }
    return success;
}

#pragma mark -
#pragma mark properties

- (dispatch_queue_t)queue
{
    if (!queue)
    {
        NSString *queueName = [NSString stringWithFormat:@"%d.org.okolodev.reachability", self.hash];
        queue = dispatch_queue_create([queueName cStringUsingEncoding:NSASCIIStringEncoding], NULL);
    }
    return queue;
}

- (NSString *)notificationName
{
    return [NSString stringWithFormat:@"%@.%d", kSCNetworkReachabilityChangedNotification,
                     self.hash];
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

@end
