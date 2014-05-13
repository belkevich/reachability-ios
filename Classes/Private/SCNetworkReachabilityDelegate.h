//
//  SCNetworkReachabilityProtocol.h
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 12/05/13
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCNetworkStatus.h"

@class SCNetworkReachability;

@protocol SCNetworkReachabilityDelegate <NSObject>

@required
- (void)reachability:(SCNetworkReachability *)reachability didChangeStatus:(SCNetworkStatus)status;

@end
