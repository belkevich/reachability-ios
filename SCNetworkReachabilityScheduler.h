//
//  SCNetworkReachabilityScheduler.h
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 12/05/13
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "SCNetworkReachabilityDelegate.h"


@interface SCNetworkReachabilityScheduler : NSObject
{
@private
    SCNetworkReachabilityRef ref;
    __weak NSObject <SCNetworkReachabilityDelegate> *delegate;
}

// initialization
- (id)initWithReachabilityRef:(SCNetworkReachabilityRef)aRef
                     delegate:(NSObject <SCNetworkReachabilityDelegate> *)aDelegate;

@end
