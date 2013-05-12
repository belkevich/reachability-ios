//
//  SCNetworkReachabilityScheduler.h
//  MyReachability
//
//  Created by Alexey Belkevich on 9/15/12.
//  Copyright (c) 2012 ClockworkIdeas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "SCNetworkReachabilityDelegate.h"


@interface SCNetworkReachabilityScheduler : NSObject
{
    SCNetworkReachabilityRef ref;
    __weak NSObject <SCNetworkReachabilityDelegate> *delegate;
}

// initialization
- (id)initWithReachabilityRef:(SCNetworkReachabilityRef)aRef
                     delegate:(NSObject <SCNetworkReachabilityDelegate> *)aDelegate;

@end
