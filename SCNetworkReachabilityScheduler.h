//
//  SCNetworkReachabilityScheduler.h
//  MyReachability
//
//  Created by Alexey Belkevich on 9/15/12.
//  Copyright (c) 2012 ClockworkIdeas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@class SCNetworkReachability;

@interface SCNetworkReachabilityScheduler : NSObject

// actions
+ (void)scheduleReachability:(SCNetworkReachability *)reachability
                     withRef:(SCNetworkReachabilityRef)ref;
+ (void)unscheduleReachabilityRef:(SCNetworkReachabilityRef)ref;

@end
