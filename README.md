Network reachability for iOS
============

## About
Painless network reachability with delegate and blocks support. 

#### Details 
SCNetworkReachability class is the wrapper on C-structures and C-functions of [SCNetworkReachability API](https://developer.apple.com/library/mac/#documentation/SystemConfiguration/Reference/SCNetworkReachabilityRef/Reference/reference.html#//apple_ref/doc/uid/TP40007260) in [SystemConfiguration.framework](https://developer.apple.com/library/mac/#documentation/Networking/Reference/SysConfig/_index.html#//apple_ref/doc/uid/TP40001027)

#### Differences from [Apple's reachability](http://developer.apple.com/library/ios/#samplecode/Reachability/Introduction/Intro.html)
* No `NSNotificationCenter`. Use blocks or delegate is your choice.
* No "code smell". All code is in OOP-style.
* ARC support

## Installation
#### Add with cocoa pods
Add to [Podfile](https://github.com/CocoaPods/CocoaPods/wiki/A-Podfile)
`pod 'SCNetworkReachability'`
And run command
`pod install`

#### Add as git submodule
	cd <project source directory>
	git submodule add https://github.com/belkevich/reachability-ios.git <submodules directory>

Then add files to your XCode project. And add `SystemConfiguration.framework` 
to your `Target` -> `Build phases` -> `Link Binary With Libraries`

## Check reachability status
```objective-c
SCNetworkReachability *reachability = [[SCNetworkReachability alloc] initWithHostName:@"www.github.com"];
if (reachability.status == SCNetworkStatusNotReachable)
{
  	// no internet connection
} 
else
{
  	// do network routine
}
```
### Note
> Requires ARC

#### Check is connection Wi-Fi or Cellular
``` objective-c
SCNetworkReachability *reachability = [[SCNetworkReachability alloc] initWithHostName:@"www.github.com"];
if (reachability.status == SCNetworkStatusViaCellular)
{
  	// internet connection via cellular
} 
else if (reachability.status == SCNetworkStatusViaWiFi)
{
  	// internet connection via Wi-Fi 
}
else
{
    // internet connection not reachable
}
```
### Note
> In OS X 'cellular' means any network access (LAN, Bluetooth) except WiFi

## Check reachability status changed
#### Delegate
Class that checks changes should implement `SCNetworkReachabilityDelegate` protocol methods:
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
SCNetworkReachability *reachability = [[SCNetworkReachability alloc] initWithHostName:@"www.github.com"];
reachability.delegate = self;
```

#### Blocks
Change block
``` objective-c
SCNetworkReachability *reachability = [[SCNetworkReachability alloc] initWithHostName:@"www.github.com"];
reachability.changedBlock = ^(SCNetworkStatus status)
{
    // do some changes depend on status
};

```

Fail block
``` objective-c
SCNetworkReachability *reachability = [[SCNetworkReachability alloc] initWithHostName:@"www.github.com"];
reachability.failedBlock = ^(NSError *error)
{
    // show error
};
```

### Note
> If you set both delegate and block then only delegate will be called

## Compatibility with [Apple's reachability](http://developer.apple.com/library/ios/#samplecode/Reachability/Introduction/Intro.html)

I've leaved two reachability initialization methods to make it compatible with Apple's reachabililty. I've never used them but it can be useful for somebody.

#### Local WiFi
Determine WiFi reachability on device
```objective-c
reachability = [SCNetworkReachability reachabilityForLocalWiFi];
```

### Note
> If WiFi available it dones't mean that internet is available. For example it's can be local network without internet access.

#### IP-address struct
Reachability for IP-address
```objective-c
struct sockaddr_in address;
// Does anybody knows how to define this structure? =)
address = ...
reachability = [SCNetworkReachability reachabilityWithHostAddress:&address];
```
