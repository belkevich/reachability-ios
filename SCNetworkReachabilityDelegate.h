//
//  SCNetworkReachabilityProtocol.h
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 9/3/12.
//  Copyright (c) 2012 ClockworkIdeas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCNetworkReachability;

@protocol SCNetworkReachabilityDelegate <NSObject>

@required
- (void)reachabilityDidChange:(SCNetworkReachability *)reachability;

@optional
- (void)reachability:(SCNetworkReachability *)reachability didFail:(NSError *)error;

@end
