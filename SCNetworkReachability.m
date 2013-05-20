//
//  SCNetworkReachability.m
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 12/05/13
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "SCNetworkReachability.h"
#import "SCNetworkReachabilityScheduler.h"
#import "SCNetworkReachabilityRefBuilder.h"

@interface SCNetworkReachability ()

@property (nonatomic, assign, readwrite) SCNetworkStatus status;
@property (nonatomic, strong, readwrite) id observer;

- (void)observeReachabilityChangedNotificationName:(NSString *)name;
- (void)updateReachabilityStatus:(SCNetworkStatus)status;

@end

@implementation SCNetworkReachability

#pragma mark -
#pragma mark main routine

- (id)initWithReachabilityRef:(SCNetworkReachabilityRef)reachabilityRef
{
    self = [self init];
    if (self)
    {
        self.status = SCNetworkStatusUndefined;
        scheduler = [[SCNetworkReachabilityScheduler alloc] initWithReachabilityRef:reachabilityRef];
        [self observeReachabilityChangedNotificationName:scheduler.notificationName];
        if ([scheduler startReachabilityObserver])
        {
            return self;
        }
    }
    return nil;
}

- (id)initWithHostName:(NSString *)hostName
{
    SCNetworkReachabilityRef reachabilityRef;
    reachabilityRef = [SCNetworkReachabilityRefBuilder reachabilityRefWithHostName:hostName];
    return [self initWithReachabilityRef:reachabilityRef];
}

- (id)initWithHostAddress:(const struct sockaddr_in *)hostAddress
{
    SCNetworkReachabilityRef reachabilityRef = nil;
    reachabilityRef = [SCNetworkReachabilityRefBuilder reachabilityRefWithHostAddress:hostAddress];
    return [self initWithReachabilityRef:reachabilityRef];
}

- (id)initForLocalWiFi
{
    SCNetworkReachabilityRef reachabilityRef;
    reachabilityRef = [SCNetworkReachabilityRefBuilder reachabilityRefForLocalWiFi];
    return [self initWithReachabilityRef:reachabilityRef];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
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
#pragma mark private

- (void)observeReachabilityChangedNotificationName:(NSString *)name
{
    __weak SCNetworkReachability *weakSelf = self;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    self.observer = [center addObserverForName:name object:nil queue:queue
                                    usingBlock:^(NSNotification *notification)
    {
        NSNumber *number = notification.object;
        [weakSelf updateReachabilityStatus:(SCNetworkStatus)[number integerValue]];
    }];
}


- (void)updateReachabilityStatus:(SCNetworkStatus)status
{
    self.status = status;
    if (self.delegate)
    {
        [self.delegate reachabilityDidChange:self.status];
    }
    else if (self.changedBlock)
    {
        self.changedBlock(self.status);
    }
}

@end
