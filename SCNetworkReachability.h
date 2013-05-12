//
//  SCNetworkReachability.h
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 12/05/13
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <netinet/in.h>
#import "SCNetworkReachabilityDelegate.h"
#import "SCNetworkStatus.h"

typedef void (^SCNetworkReachabilityChanged)(SCNetworkStatus status);
typedef void (^SCNetworkReachabilityFailed)(NSError *error);

@class SCNetworkReachabilityScheduler;

@interface SCNetworkReachability : NSObject
{
    SCNetworkReachabilityScheduler *scheduler;
}

@property (nonatomic, weak, readwrite) NSObject <SCNetworkReachabilityDelegate> *delegate;
@property (nonatomic, strong, readwrite) SCNetworkReachabilityChanged changedBlock;
@property (nonatomic, strong, readwrite) SCNetworkReachabilityFailed failedBlock;
@property (nonatomic, assign, readonly) SCNetworkStatus status;

// initialization
- (id)initWithHostName:(NSString *)hostName;
- (id)initWithHostAddress:(const struct sockaddr_in *)hostAddress;
- (id)initForLocalWiFi;
// static initialization
+ (SCNetworkReachability *)reachabilityWithHostName:(NSString *)hostName;
+ (SCNetworkReachability *)reachabilityWithHostAddress:(const struct sockaddr_in *)hostAddress;
+ (SCNetworkReachability *)reachabilityForLocalWiFi;

@end
