//
//  SCNetworkReachability+Multithreading.h
//  ReachabilityApp
//
//  Created by Alexey Belkevich on 4/24/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "SCNetworkReachability.h"

@interface SCNetworkReachability (Multithreading)

- (void)observeReachabilityOnDispatchQueue:(dispatch_queue_t)queue
                                  callback:(void (^)(SCNetworkStatus))block;
- (void)reachabilityStatusOnDispatchQueue:(dispatch_queue_t)queue
                                 callback:(void (^)(SCNetworkStatus))block;
+ (void)hostReachabilityStatus:(NSString *)host onDispatchQueue:(dispatch_queue_t)queue
                      callback:(void (^)(SCNetworkStatus))block;

@end
