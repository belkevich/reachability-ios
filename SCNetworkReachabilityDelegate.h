//
//  SCNetworkReachabilityProtocol.h
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 12/05/13
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCNetworkStatus.h"

@protocol SCNetworkReachabilityDelegate <NSObject>

@required
- (void)reachabilityDidChange:(SCNetworkStatus)status;

@end
