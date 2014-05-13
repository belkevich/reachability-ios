//
//  SCReachabilityRefBuilder.m
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 12/05/13
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "SCReachabilityRefBuilder.h"

NSString * const kSCEmptyHostException = @"SCNetworkReachability: Host Name is Empty";

@implementation SCReachabilityRefBuilder

#pragma mark - public

+ (SCNetworkReachabilityRef)reachabilityRefWithHostName:(NSString *)hostName
{
    if (hostName.length > 0)
    {
        hostName = [self trimProtocolFromHostName:hostName];
        return SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
    }
    @throw [NSException exceptionWithName:kSCEmptyHostException reason:kSCEmptyHostException
                                 userInfo:nil];
}

#pragma mark - private

+ (NSString *)trimProtocolFromHostName:(NSString *)hostName
{
    NSRange range = [hostName rangeOfString:@"://"];
    if (range.location != NSNotFound)
    {
        return [hostName substringFromIndex:(range.location + range.length)];
    }
    return hostName;
}

@end
