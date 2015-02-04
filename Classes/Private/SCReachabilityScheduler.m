//
//  SCReachabilityScheduler.m
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 12/05/13
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "SCReachabilityScheduler.h"
#import "SCReachabilityFlagsParser.h"

static void callbackForReachabilityRef(SCNetworkReachabilityRef target,
                                       SCNetworkReachabilityFlags flags, void *data);

@interface SCReachabilityScheduler ()
{
    SCNetworkReachabilityRef _reachabilityRef;
    dispatch_queue_t _queue;
}
@property (nonatomic, copy) void (^statusChangesBlock)(SCNetworkStatus status);
@end

@implementation SCReachabilityScheduler

#pragma mark - life cycle

- (id)initWithReachabilityRef:(SCNetworkReachabilityRef)reachabilityRef statusChangesBlock:(void (^)(SCNetworkStatus status))statusChangesBlock
{
    self = [super init];
    if (self)
    {
        _reachabilityRef = reachabilityRef;
        _statusChangesBlock = statusChangesBlock;
        NSString *name = [NSString stringWithFormat:@"org.okolodev.reachability.%lu",
                          (unsigned long)self.hash];
        _queue = dispatch_queue_create([name UTF8String], NULL);
        SCNetworkReachabilityContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
        if (SCNetworkReachabilitySetCallback(_reachabilityRef, callbackForReachabilityRef, &context))
        {
            SCNetworkReachabilitySetDispatchQueue(_reachabilityRef, _queue);
        }
    }
    return self;
}

- (void)dealloc
{
    if (_reachabilityRef)
    {
        SCNetworkReachabilitySetDispatchQueue(_reachabilityRef, NULL);
        CFRelease(_reachabilityRef);
    }
#if !OS_OBJECT_USE_OBJC
    if (_queue)
    {
        dispatch_release(_queue);
    }
#endif
}

#pragma mark - callback

static void callbackForReachabilityRef(SCNetworkReachabilityRef __unused target,
                                       SCNetworkReachabilityFlags flags, void *data)
{
    SCReachabilityScheduler *scheduler = (__bridge SCReachabilityScheduler *)data;
    SCNetworkStatus status = [SCReachabilityFlagsParser statusWithFlags:flags];
    scheduler.statusChangesBlock ? scheduler.statusChangesBlock(status) : nil;
}

@end
