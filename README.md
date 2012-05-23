# RemoteConfig
Load a remote JSON / XML config file with locally defined default values.


## Installation
1. Drag the RemoteConfig folder to your project. Check "copy items into destination group's folder" and the target.
2. In your project settings go to the build fases. In the "compile sources" section add the `-fno-objc-arc` flag to `KJMJSONUtilities.m`.


## How to get started
Create a subclass of KJMJSONRemoteConfig or KJMXMLRemoteConfig and override the following methods:

* `- (NSURL *)remoteFileLocation;` (required)
* `- (NSString *)localFileLocation;` (optional, default value is config.plist in the Documents directory)
* `- (void)setupMapping;` (required)

It's recommended (but not required) to add synthesized properties for your config values.


### Example

```objective-c
// Config.h
#import "KJMJSONRemoteConfig.h"

@interface Config : JSONRemoteConfig

@property (strong, nonatomic) NSNumber *rateAppAfter;
@property (strong, nonatomic) NSString *rateAppUrl;

+ (Config *)config;

@end
```

```objective-c
// Config.m
#import "Config.h"

@implementation Config

@synthesize rateAppAfter = _rateAppAfter;
@synthesize rateAppUrl = _rateAppUrl;

+ (Config *)config {
    static dispatch_once_t pred;
    static Config *sharedInstance = nil;
    dispatch_once(&pred, ^{ sharedInstance = [[self alloc] init]; });
    return sharedInstance;
}

- (NSURL *)remoteFileLocation {
    return [NSURL URLWithString:@"http://dl.dropbox.com/u/2310965/remoteconfigexample.json"];
}

- (void)setupMapping {
    [self mapRemoteKeyPath:@"rate_app_after" toLocalAttribute:@"rateAppAfter" defaultValue:[NSNumber numberWithInteger:5]];
    [self mapRemoteKeyPath:@"rate_app_url" toLocalAttribute:@"rateAppUrl" defaultValue:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=323701765"];
}

@end
```

### Usage
Use the singleton method to access your config values:

```objective-c
[Config config].rateAppAfter;
[Config config].rateAppUrl;
```

If the remote config file has not yet been downloaded and parsed, default values will be used for these properties.


## Requirements

### JSON
RemoteConfig uses [`NSJSONSerialization`](http://developer.apple.com/library/mac/#documentation/Foundation/Reference/NSJSONSerialization_Class/Reference/Reference.html) for JSON files, if it is available. If your app targets a platform where this class is not available you can include one of the following JSON libraries to your project for RemoteConfig to automatically detect and use.

* [JSONKit](https://github.com/johnezang/JSONKit)
* [SBJson](https://stig.github.com/json-framework/)
* [YAJL](https://lloyd.github.com/yajl/)
* [NextiveJson](https://github.com/nextive/NextiveJson)

If you're not using JSON based config files, you don't need to include any of them.

### ARC Support
RemoteConfig requires ARC support. However, `KJMJSONUtilities.m` needs to be compiled with the `-fno-objc-arc` flag. To do this in Xcode, go to your active target and select the "Build Phases" tab. In the "Compiler Flags" column, set `-fno-objc-arc` for `KJMJSONUtilities.m`.


## Issues and questions
Have a bug? Please create an issue on GitHub!

https://github.com/kevinrenskers/RemoteConfig/issues


## Contributing
RemoteConfig is an open source project and your contribution is very much appreciated.

1. Check for [open issues](https://github.com/kevinrenskers/RemoteConfig/issues) or [open a fresh issue](https://github.com/kevinrenskers/RemoteConfig/issues/new) to start a discussion around a feature idea or a bug.
2. Fork the [repository on Github](https://github.com/kevinrenskers/RemoteConfig) and make your changes on the **develop** branch (or branch off of it).
3. Make sure to add yourself to AUTHORS and send a pull request.


## Credits
Thanks go to:

* [AFNetworking](https://github.com/AFNetworking/AFNetworking/) for the `KJMJSONUtilities` wrapper around multiple JSON libraries.
* [XML-to-NSDictionary](https://github.com/Coeur/XML-to-NSDictionary) for the `KJMXMLReader` class.


## License
RemoteConfig is available under the MIT license. See the LICENSE file for more info.
