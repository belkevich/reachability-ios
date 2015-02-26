//
//  SCNetworkReachability.m
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 12/05/13
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "SCNetworkReachability.h"
#import "SCReachabilityRefBuilder.h"
#import "SCReachabilityScheduler.h"
#import "SCReachabilityFlagsParser.h"
#import "macros_blocks.h"

NSString *const kReachabilityDefaultHost = @"www.google.com";

@interface SCNetworkReachability ()
{
    SCReachabilityScheduler *_scheduler;
}

@property (atomic, assign) BOOL isStatusValid;
@property (atomic, assign) SCNetworkStatus status;
@property (nonatomic, copy) void (^observationBlock)(SCNetworkStatus status);
@property (nonatomic, copy) void (^statusBlock)(SCNetworkStatus status);
@end

@implementation SCNetworkReachability

#pragma mark - life cycle

- (id)init
{
    return [self initWithHost:kReachabilityDefaultHost];
}

- (id)initWithHost:(NSString *)host
{
    SCNetworkReachabilityRef reachabilityRef;
    reachabilityRef = [SCReachabilityRefBuilder reachabilityRefWithHostName:host];
    self = [self initWithReachabilityRef:reachabilityRef];
    if (self)
    {
        _host = host;
    }
    return self;
}

- (id)initWithReachabilityRef:(SCNetworkReachabilityRef)reachabilityRef
{
    self = [super init];
    if (self)
    {
        _scheduler = [[SCReachabilityScheduler alloc] initWithReachabilityRef:reachabilityRef];
        __weak __typeof (self) weakSelf = self;
        [_scheduler observeStatusChanges:^(SCNetworkStatus status)
        {
            if (!weakSelf.isStatusValid && weakSelf.statusBlock)
            {
                weakSelf.statusBlock(status);
                weakSelf.statusBlock = nil;
            }
            weakSelf.isStatusValid = YES;
            weakSelf.status = status;
            weakSelf.observationBlock ? weakSelf.observationBlock(status) : nil;
        }];
    }
    return self;
}

#pragma mark - public

- (void)observeReachability:(void (^)(SCNetworkStatus status))block
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    [self observeReachabilityOnDispatchQueue:queue callback:block];
}

- (void)reachabilityStatus:(void (^)(SCNetworkStatus status))block
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    [self reachabilityStatusOnDispatchQueue:queue callback:block];
}

+ (void)host:(NSString *)host reachabilityStatus:(void (^)(SCNetworkStatus status))block
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    [self hostReachabilityStatus:host onDispatchQueue:queue callback:block];
}

#pragma mark - private

- (void)observeReachabilityOnDispatchQueue:(dispatch_queue_t)queue
                                  callback:(void (^)(SCNetworkStatus))block
{
    self.observationBlock = ^(SCNetworkStatus status)
    {
        async_queue_block(queue, block, status);
    };
    if (self.isStatusValid)
    {
        self.observationBlock(self.status);
    }
}

- (void)reachabilityStatusOnDispatchQueue:(dispatch_queue_t)queue
                                 callback:(void (^)(SCNetworkStatus))block
{
    if (block)
    {
        [self updateStatusBlockWithDispatchQueue:queue block:block];
        if (self.isStatusValid)
        {
            self.statusBlock(self.status);
        }
    }
}

+ (void)hostReachabilityStatus:(NSString *)host onDispatchQueue:(dispatch_queue_t)queue
                      callback:(void (^)(SCNetworkStatus))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        SCNetworkReachabilityRef reachabilityRef;
        reachabilityRef = [SCReachabilityRefBuilder reachabilityRefWithHostName:host];
        SCNetworkReachabilityFlags flags;
        SCNetworkReachabilityGetFlags(reachabilityRef, &flags);
        SCNetworkStatus status = [SCReachabilityFlagsParser statusWithFlags:flags];
        CFRelease(reachabilityRef);
        async_queue_block(queue, block, status);
    });
}

- (void)updateStatusBlockWithDispatchQueue:(dispatch_queue_t)queue
                                     block:(void (^)(SCNetworkStatus))block
{
    if (self.statusBlock)
    {
        void (^previousBlock)(SCNetworkStatus status) = self.statusBlock;
        self.statusBlock = ^(SCNetworkStatus status)
        {
            previousBlock(status);
            async_queue_block(queue, block, status);
        };
    }
    else
    {
        self.statusBlock = ^(SCNetworkStatus status)
        {
            async_queue_block(queue, block, status);
        };
    }
}

@end
