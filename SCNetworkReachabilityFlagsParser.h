//
//  SCNetworkReachabilityFlagsParser.h
//  MyReachability
//
//  Created by Alexey Belkevich on 9/15/12.
//  Copyright (c) 2012 ClockworkIdeas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "SCNetworkStatus.h"

@interface SCNetworkReachabilityFlagsParser : NSObject
{
@private
    SCNetworkReachabilityFlags flags;
}

// initialization
- (id)initWithReachabilityFlags:(SCNetworkReachabilityFlags)aFlags;
- (id)initWithReachabilityRef:(SCNetworkReachabilityRef)reachabilityRef;
// actions
- (SCNetworkStatus)status;

@end
