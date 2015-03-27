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

- (id)initWithReachabilityRef:(SCNetworkReachabilityRef)reachabilityRef
{
    self = [super init];
    if (self)
    {
        _reachabilityRef = reachabilityRef;
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

#pragma mark - public

- (void)observeStatusChanges:(void (^)(SCNetworkStatus status))statusChangesBlock
{
    BOOL isStatusChangesBlockEmpty = self.statusChangesBlock == nil;
    self.statusChangesBlock = statusChangesBlock;
    if (isStatusChangesBlockEmpty)
    {
        [self scheduleStatusChangesCallback];
    }
}

#pragma mark - private

- (void)scheduleStatusChangesCallback
{
    NSString *name = [NSString stringWithFormat:@"org.okolodev.reachability.%lu",
                                                (unsigned long)self.hash];
    _queue = dispatch_queue_create([name UTF8String], NULL);
    SCNetworkReachabilityContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
    if (SCNetworkReachabilitySetCallback(_reachabilityRef, callbackForReachabilityRef, &context))
    {
        SCNetworkReachabilitySetDispatchQueue(_reachabilityRef, _queue);
    }
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
