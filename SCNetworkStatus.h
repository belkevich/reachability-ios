//
//  SCNetworkStatus.h
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 12/05/13
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    SCNetworkStatusNotReachable = 0,
    SCNetworkStatusReachableViaWiFi = 1,
    SCNetworkStatusReachableViaCellular = 2
} SCNetworkStatus;
