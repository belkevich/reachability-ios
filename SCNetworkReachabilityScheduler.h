//
//  SCNetworkReachabilityScheduler.h
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 12/05/13
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface SCNetworkReachabilityScheduler : NSObject
{
@private
    SCNetworkReachabilityRef ref;
    dispatch_queue_t queue;
}

@property (nonatomic, strong, readonly) NSString *notificationName;

// initialization
- (id)initWithReachabilityRef:(SCNetworkReachabilityRef)aRef;
- (BOOL)startReachabilityObserver;

@end
