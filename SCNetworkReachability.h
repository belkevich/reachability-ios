//
//  SCNetworkReachability.h
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 9/3/12.
//  Copyright (c) 2012 ClockworkIdeas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import "SCNetworkReachabilityDelegate.h"

typedef enum
{
    SCNetworkStatusNotReachable = 0,
    SCNetworkStatusReachableViaWiFi = 1,
    SCNetworkStatusReachableViaCellular = 2
}
SCNetworkStatus;

@interface SCNetworkReachability : NSObject
{
    SCNetworkReachabilityRef reachabilityRef;
    NSObject <SCNetworkReachabilityDelegate> *delegate;
    SCNetworkStatus status;
}

@property (nonatomic, weak) NSObject <SCNetworkReachabilityDelegate> *delegate;
@property (nonatomic, readonly) SCNetworkStatus status;

// initialization
- (id)initWithHostName:(NSString *)hostName;
- (id)initWithHostAddress:(const struct sockaddr_in *)hostAddress;
- (id)initForLocalWiFi;
// static initialization
+ (SCNetworkReachability *)reachabilityWithHostName:(NSString *)hostName;
+ (SCNetworkReachability *)reachabilityWithHostAddress:(const struct sockaddr_in *)hostAddress;
+ (SCNetworkReachability *)reachabilityForLocalWiFi;
// actions
- (void)checkReachability;

@end
