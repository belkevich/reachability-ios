Network reachability for iOS
============
---
# About
SCNetworkReachability class is the wrapper on C-structures and C-functions of [SCNetworkReachability API](https://developer.apple.com/library/mac/#documentation/SystemConfiguration/Reference/SCNetworkReachabilityRef/Reference/reference.html#//apple_ref/doc/uid/TP40007260) in [SystemConfiguration.framework](https://developer.apple.com/library/mac/#documentation/Networking/Reference/SysConfig/_index.html#//apple_ref/doc/uid/TP40001027)

# Installation
## 1. Installing with cocoa pods

Add to [Podfile](https://github.com/CocoaPods/CocoaPods/wiki/A-Podfile)
`pod 'SCNetworkReachability'`
And run command
`pod install`

## 2. Add as git submodule

	cd <project source directory>
	git submodule add https://github.com/belkevich/reachability-ios.git <submodules directory>

Then add files to your XCode project. And add `SystemConfiguration.framework` 
to your `Target` -> `Build phases` -> `Link Binary With Libraries`

# Using
## Check internet connection now

```objective-c
SCNetworkReachability *reachability = [[SCNetworkReachability alloc] initWithHostName:@"www.apple.com"];
if (reachability.status == SCNetworkStatusNotReachable)
{
	// no internet connection
} 
else
{
	// do network connection
}
```

## Check is connection Wi-Fi or Cellular

``` objective-c
SCNetworkReachability *reachability = [[SCNetworkReachability alloc] initWithHostName:@"www.apple.com"];
if (reachability.status == SCNetworkStatusViaCellular)
{
	// internet connection via cellular
} 
else if (reachability.status == SCNetworkStatusViaWiFi)
{
	// internet connection via Wi-Fi 
}
```

## Check is connection status changed

Class that will be check changes should implement `SCNetworkReachabilityDelegate` protocol methods:

``` objective-c
@protocol SCNetworkReachabilityDelegate <NSObject>

@required
- (void)reachabilityDidChange:(SCNetworkReachability *)reachability;

@optional
- (void)reachability:(SCNetworkReachability *)reachability didFail:(NSError *)error;

@end
```

And set reachability instance delegate to self

``` objective-c
SCNetworkReachability *reachability = [[SCNetworkReachability alloc] initWithHostName:@"www.apple.com"];
reachability.delegate = self;
```
