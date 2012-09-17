//
//  SCNetworkReachabilityFlagsParser.h
//  MyReachability
//
//  Created by Alexey Belkevich on 9/15/12.
//  Copyright (c) 2012 ClockworkIdeas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface SCNetworkReachabilityFlagsParser : NSObject
{
@private
    SCNetworkReachabilityFlags flags;
}

// initialization
- (id)initWithReachabilityRef:(SCNetworkReachabilityRef)reachabilityRef;
// actions
- (BOOL)checkReachabilityRefFlags:(SCNetworkReachabilityRef)reachabilityRef;
- (BOOL)isReachable;
- (BOOL)isCellular;

@end
