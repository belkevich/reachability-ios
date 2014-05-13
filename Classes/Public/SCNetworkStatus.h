//
//  SCNetworkStatus.h
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 12/05/13
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SCNetworkStatus)
{
    SCNetworkStatusNotReachable = 0,
#if TARGET_OS_IPHONE
    SCNetworkStatusReachableViaWiFi = 1,
    SCNetworkStatusReachableViaCellular = 2
#else
    SCNetworkStatusReachable = 3
#endif
};