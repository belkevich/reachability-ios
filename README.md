Network reachability for iOS and OS X
============

#### About
SCNetworkReachability class is the wrapper on C-structures and C-functions of [SCNetworkReachability API](https://developer.apple.com/library/mac/#documentation/SystemConfiguration/Reference/SCNetworkReachabilityRef/Reference/reference.html#//apple_ref/doc/uid/TP40007260) in [SystemConfiguration.framework](https://developer.apple.com/library/mac/#documentation/Networking/Reference/SysConfig/_index.html#//apple_ref/doc/uid/TP40001027)

###### Differences from [Apple's reachability](http://developer.apple.com/library/ios/#samplecode/Reachability/Introduction/Intro.html)
* No `NSNotificationCenter`. Use callback blocks to determine reachability status or observe changes
* No synchronous reachability checks. Your app will not crash because of bad connection
* No "code smell". All code is in OOP-style.
* OS X support

#### Installation

Add `pod 'SCNetworkReachability'` to [Podfile](https://github.com/CocoaPods/CocoaPods/wiki/A-Podfile)

#### Using

##### Check reachability status
Check current reachability status of some host. This callback will run only once immediately after reachability status will be determined.
**Note. Callback block will run on main queue!**
```objective-c
SCNetworkReachability *reachability = [[SCNetworkReachability alloc] initWithHost:@"https://github.com"];
[reachability reachabilityStatus:^(SCNetworkStatus status)
{
    switch (status)
    {
        case SCNetworkStatusReachableViaWiFi:
            NSLog(@"Reachable via WiFi");
            break;

        case SCNetworkStatusReachableViaCellular:
            NSLog(@"Reachable via Cellular");
            break;

        case SCNetworkStatusNotReachable:
            NSLog(@"Not Reachable");
            break;
    }
}];
```

And if you don't want to store instance of `SCNetworkReachability` you can do the same with class method.
```objective-c
[SCNetworkReachability host:@"github.com" reachabilityStatus:^(SCNetworkStatus status)
{
    switch (status)
    {
        case SCNetworkStatusReachableViaWiFi:
            NSLog(@"Reachable via WiFi");
            break;

        case SCNetworkStatusReachableViaCellular:
            NSLog(@"Reachable via Cellular");
            break;

        case SCNetworkStatusNotReachable:
            NSLog(@"Not Reachable");
            break;
    }
}];
```
**Note. There is only one difference from iOS that you have only one status `SCNetworkStatusReachable` instead of `SCNetworkStatusReachableViaWiFi` and `SCNetworkStatusReachableViaCellular`.**


##### Observe reachability changes
Observe reachability changes of some host. This callback will run each time reachability status will be changed.
```objective-c
SCNetworkReachability *reachability = [[SCNetworkReachability alloc] initWithHost:@"example.com"];
[reachability observeReachability:^(SCNetworkStatus status)
{
    switch (status)
    {
        case SCNetworkStatusReachableViaWiFi:
            NSLog(@"Reachable via WiFi");
            break;

        case SCNetworkStatusReachableViaCellular:
            NSLog(@"Reachable via Cellular");
            break;

        case SCNetworkStatusNotReachable:
            NSLog(@"Not Reachable");
            break;
    }
}];
```

#### Multithreading
Sometimes you need to check reachability not on main queue. And it's easy with `Multithreading` subspec.

##### Installation

Add `pod 'SCNetworkReachability/Multithreading'` to Podfile.

##### Using
`Multithreading` subspec allows to set custom [dispatch queue](https://developer.apple.com/library/ios/documentation/General/Conceptual/ConcurrencyProgrammingGuide/OperationQueues/OperationQueues.html) for callbacks. So you can choose any of this methods.
```objective-c
- (void)observeReachabilityOnDispatchQueue:(dispatch_queue_t)queue
                                  callback:(void (^)(SCNetworkStatus))block;
- (void)reachabilityStatusOnDispatchQueue:(dispatch_queue_t)queue
                                 callback:(void (^)(SCNetworkStatus))block;
+ (void)hostReachabilityStatus:(NSString *)host onDispatchQueue:(dispatch_queue_t)queue
                      callback:(void (^)(SCNetworkStatus))block;
```

#### Shared reachability
Another useful subspec is `Shared`. It creates shared instance of `SCNetworkReachability` class.

##### Installation

Add `pod 'SCNetworkReachability/Shared'` to Podfile.

##### Using
```objective-c
SCNetworkReachability *reachability = SCNetworkReachability.shared;
```

#### Compatibility with [Apple's reachability](http://developer.apple.com/library/ios/#samplecode/Reachability/Introduction/Intro.html)
I've leaved two reachability initialisation methods to make it compatible with Apple's reachabililty. I've never used them but it can be useful for someone.

##### Installation

Add `pod 'SCNetworkReachability/Compatibility'` to Podfile.

##### Using
Determine WiFi reachability on device. Available only on iOS.
```objective-c
SCNetworkReachability *reachability = [[SCNetworkReachability alloc] initForLocalWiFi];
```

Reachability with IP-address struct
```objective-c
struct sockaddr_in address;
// Does anybody knows how to define this structure? =)
address = ...
SCNetworkReachability *reachability = [[SCNetworkReachability alloc] initWithHostAddress:&address];
```

#### History
[Releases](https://github.com/belkevich/reachability-ios/releases)

#### Updates
Follow updates on twitter [@okolodev](https://twitter.com/okolodev)
