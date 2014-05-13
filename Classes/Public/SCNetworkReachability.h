//
//  SCNetworkReachability.h
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 12/05/13
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCNetworkStatus.h"

@interface SCNetworkReachability : NSObject

@property (nonatomic, readonly) NSString *host;

- (id)initWithHost:(NSString *)host;
- (void)observeReachability:(void (^)(SCNetworkStatus status))block;
- (void)reachabilityStatus:(void (^)(SCNetworkStatus status))block;
+ (void)host:(NSString *)host reachabilityStatus:(void (^)(SCNetworkStatus status))block;

@end
