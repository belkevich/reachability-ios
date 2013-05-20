Network reachability for iOS
============

## About
Painless network reachability with delegate and blocks support. 

#### Details 
SCNetworkReachability class is the wrapper on C-structures and C-functions of [SCNetworkReachability API](https://developer.apple.com/library/mac/#documentation/SystemConfiguration/Reference/SCNetworkReachabilityRef/Reference/reference.html#//apple_ref/doc/uid/TP40007260) in [SystemConfiguration.framework](https://developer.apple.com/library/mac/#documentation/Networking/Reference/SysConfig/_index.html#//apple_ref/doc/uid/TP40001027)

#### Differences from [Apple's reachability](http://developer.apple.com/library/ios/#samplecode/Reachability/Introduction/Intro.html)
* No `NSNotificationCenter`. Use blocks or delegate is your choice.
* No "code smell". All code is in OOP-style.
* No synchronous reachability checks. Your app will not crash because of bad connection
* Thread safety. Delegate or block will run in the same thread where `reachability` was created
* OS X support
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

###### Note
> If your app use manual memory management then don't forget to convert SCNetworkReachability to ARC!

## Using

#### Check reachability status using delegate
Class that checks changes should conforms to `SCNetworkReachabilityDelegate` protocol:
``` objective-c
@interface MyClass : NSObject <SCNetworkReachabilityDelegate>
...
```
And implement method:
```objective-c
- (void)reachabilityDidChange:(SCNetworkStatus)status
{
    switch (status)
    {
        case SCNetworkStatusReachableViaWiFi:
        case SCNetworkStatusReachableViaCellular:
            // do network routine
            break;
        case SCNetworkStatusNotReachable:
            // show error, release connection, etc.
            break;
        default:
            break;  
}
```
Then create `reachability` instance and set `delegate` to `self`:
``` objective-c
SCNetworkReachability *reachability = [[SCNetworkReachability alloc] initWithHostName:@"www.github.com"];
reachability.delegate = self;
```
And delegate will be called as soon as reachability status will be determined
###### Note
> If you check status immediately after `reachability` creation you will get `SCNetworkStatusUndefined`. It happens because reachability status determination process is asynchronous and some time should pass before you can use `reachability.status`

#### Check reachability status using block
``` objective-c
SCNetworkReachability *reachability = [[SCNetworkReachability alloc] initWithHostName:@"www.github.com"];
reachability.changedBlock = ^(SCNetworkStatus status)
{
    // do some work depend on status
};

```
###### Note
> If you set both delegate and block then only delegate will be called

#### Check reachability status on OS X
There is only one difference from iOS that you have only one status `SCNetworkStatusReachable` instead of `SCNetworkStatusReachableViaWiFi` and `SCNetworkStatusReachableViaCellular`.

## Compatibility with [Apple's reachability](http://developer.apple.com/library/ios/#samplecode/Reachability/Introduction/Intro.html)

I've leaved two reachability initialization methods to make it compatible with Apple's reachabililty. I've never used them but it can be useful for someone.

#### Reachability with local WiFi
Determine WiFi reachability on device
```objective-c
reachability = [SCNetworkReachability reachabilityForLocalWiFi];
```

###### Note
> Not available for OS X. Also, if WiFi available it dones't mean that internet is available. For example it's can be local network without internet access.

#### Reachability with IP-address struct
Reachability for IP-address
```objective-c
struct sockaddr_in address;
// Does anybody knows how to define this structure? =)
address = ...
reachability = [SCNetworkReachability reachabilityWithHostAddress:&address];
```
