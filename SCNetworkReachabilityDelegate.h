//
//  SCNetworkReachabilityProtocol.h
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 9/3/12.
//  Copyright (c) 2012 ClockworkIdeas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCNetworkStatus.h"

@protocol SCNetworkReachabilityDelegate <NSObject>

@required
- (void)reachabilityDidChange:(SCNetworkStatus)status;

@optional
- (void)reachabilityDidFail:(NSError *)error;

@end
