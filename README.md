# RemoteConfig
Objective-c library for loading a remote JSON / XML config file with locally defined default values.


## Installation
The best and easiest way is to use [CocoaPods](http://cocoapods.org).

    pod 'RemoteConfig'


## How to get started
Create a subclass of `GVJSONRemoteConfig` or `GVXMLRemoteConfig` and override the following methods:

* `- (NSURL *)remoteFileLocation;` (required)
* `- (void)setupMapping;` (required)
* `- (NSTimeInterval)redownloadRate;` (optional, by default the remote file is redownloaded every 24 hours)

It's recommended to add synthesized properties for your config values. However, key value coding also works.


### Example
See the included example app: [`Config.m`](https://github.com/gangverk/RemoteConfig/blob/master/Example/Config.m) and [`ViewController.m`](https://github.com/gangverk/RemoteConfig/blob/master/Example/ViewController.m).

To run the example app, install its dependancies via CocoaPods: `pod install`.

```
@interface Config : GVJSONRemoteConfig

@property (strong, nonatomic) NSNumber *exampleIntegerValue;
@property (strong, nonatomic) NSString *exampleStringValue;
@property (strong, nonatomic) NSString *nonExistingStringValue;

+ (Config *)sharedInstance;

@end
```

```
@implementation Config

+ (Config *)sharedInstance {
    static dispatch_once_t pred;
    static Config *sharedInstance = nil;
    dispatch_once(&pred, ^{ sharedInstance = [[self alloc] init]; });
    return sharedInstance;
}

- (NSURL *)remoteFileLocation {
    return [NSURL URLWithString:@"https://raw.github.com/gangverk/RemoteConfig/master/Example/example.json"];
}

- (void)setupMapping {
    [self mapRemoteKeyPath:@"remote_integer_value" toLocalAttribute:@"exampleIntegerValue" defaultValue:[NSNumber numberWithInteger:1]];
    [self mapRemoteKeyPath:@"remote_string_value" toLocalAttribute:@"exampleStringValue" defaultValue:@"Default local value"];
    [self mapRemoteKeyPath:@"nonexisting_string_value" toLocalAttribute:@"nonExistingStringValue" defaultValue:@"Default local value for nonexisting value on server"];
}

@end
```


## Requirements

### JSON
RemoteConfig uses [`NSJSONSerialization`](http://developer.apple.com/library/mac/#documentation/Foundation/Reference/NSJSONSerialization_Class/Reference/Reference.html) for JSON files, if it is available. If your app targets a platform where this class is not available (iOS < 5.0) you can include one of the following JSON libraries to your project for RemoteConfig to automatically detect and use.

* [JSONKit](https://github.com/johnezang/JSONKit)
* [SBJson](https://stig.github.com/json-framework/)
* [yajl_json](http://gabriel.github.com/yajl-objc/)
* [NextiveJSON](https://github.com/nextive/NextiveJson)

If you're not using JSON based config files (or if you're targeting iOS 5+), you don't need to include any of them.

### ARC Support
RemoteConfig is built using ARC and modern Objective-C syntax. You will need Xcode 4.4 or higher to use it in your project.


## Issues and questions
Have a bug? Please [create an issue on GitHub](https://github.com/gangverk/RemoteConfig/issues)!


## To do
The following items are on the to do list:

* Check the last-modified header so we don't parse data if it wasn't changed (using NSURLRequestReloadRevalidatingCacheData already limits downloading, but we're still always parsing the old data)
* Add tests


## Apps using RemoteConfig
* Last.fm Scrobbler
* MetroLyrics
* Radio.com
* Tailgate Fan

Are you using RemoteConfig in your iOS or Mac OS X app? Send a pull request with an updated README.md file to be included.


## License
RemoteConfig is available under the MIT license. See the LICENSE file for more info.
