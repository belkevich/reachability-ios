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

typedef enum
{
    SCNetworkDeviceNone = 0,
    SCNetworkDeviceWiFi = 1,
    SCNetworkDeviceCellular = 2
}
SCNetworkDevice;

@interface SCNetworkReachability : NSObject
{
    SCNetworkReachabilityRef reachabilityRef;
    SCNetworkDevice device;
    BOOL isReachable;
    NSError *error;
}

@property (nonatomic, readonly) SCNetworkDevice device;
@property (nonatomic, readonly) BOOL isReachable;
@property (nonatomic, readonly) NSError *error;

// initialization
- (id)initWithHostName:(NSString *)hostName;
- (id)initWithHostAddress:(const struct sockaddr_in *)hostAddress;
- (id)initForLocalWiFi;
// static initialization
+ (SCNetworkReachability *)reachabilityWithHostName:(NSString *)hostName;
+ (SCNetworkReachability *)reachabilityWithHostAddress:(const struct sockaddr_in *)hostAddress;
+ (SCNetworkReachability *)reachabilityForLocalWiFi;

@end
