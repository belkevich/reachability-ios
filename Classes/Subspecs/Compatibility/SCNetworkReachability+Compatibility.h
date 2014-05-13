//
//  SCNetworkReachability+Compatibility.h
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 4/19/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "SCNetworkReachability.h"
#import <netinet/in.h>

@interface SCNetworkReachability (Compatibility)

- (id)initWithHostAddress:(const struct sockaddr_in *)hostAddress;
#if TARGET_OS_IPHONE
- (id)initForLocalWiFi;
#endif

@end
