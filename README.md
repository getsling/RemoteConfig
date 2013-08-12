# RemoteConfig
Objective-c library for loading a remote JSON / XML config file with locally defined default values.


## Installation
The best and easiest way is to use [CocoaPods](http://cocoapods.org).

### Alternatives
Not using CocoaPods?

1. Get the code: `git clone git://github.com/gangverk/RemoteConfig.git`
2. Drag the `RemoteConfig` subfolder to your project. Check both "copy items into destination group's folder" and your target.
3. Add [XMLReader](https://github.com/RestKit/XML-to-NSDictionary) to your project, including its requirements (libxml2)

Alternatively you can add this code as a Git submodule:

1. `cd [your project root]`
2. `git submodule add git://github.com/gangverk/RemoteConfig.git`
3. Drag the `RemoteConfig` subfolder to your project. Uncheck the "copy items into destination group's folder" box, do check your target.


## How to get started
Create a subclass of `GVJSONRemoteConfig` or `GVXMLRemoteConfig` and override the following methods:

* `- (NSURL *)remoteFileLocation;` (required)
* `- (void)setupMapping;` (required)
* `- (NSTimeInterval)redownloadRate;` (optional, by default the remote file is redownloaded every 24 hours)

It's recommended to add synthesized properties for your config values. However, key value coding also works.


### Example
See the included example app: [`Config.m`](https://github.com/gangverk/RemoteConfig/blob/master/Example/Config.m) and [`ViewController.m`](https://github.com/gangverk/RemoteConfig/blob/master/Example/ViewController.m).

To run the example app, install its dependancies via CocoaPods: `pod install`.


## Requirements

### JSON
RemoteConfig uses [`NSJSONSerialization`](http://developer.apple.com/library/mac/#documentation/Foundation/Reference/NSJSONSerialization_Class/Reference/Reference.html) for JSON files, if it is available. If your app targets a platform where this class is not available (iOS < 5.0) you can include one of the following JSON libraries to your project for RemoteConfig to automatically detect and use.

* [JSONKit](https://github.com/johnezang/JSONKit)
* [SBJson](https://stig.github.com/json-framework/)
* [YAJL](https://lloyd.github.com/yajl/)

If you're not using JSON based config files, you don't need to include any of them.

### ARC Support
RemoteConfig is built using ARC and modern Objective-C syntax. You will need Xcode 4.4 or higher to use it in your project.


## Issues and questions
Have a bug? Please [create an issue on GitHub](https://github.com/gangverk/RemoteConfig/issues)!


## To do
The following items are on the to do list:

* Check the last-modified header so we don't parse data if it wasn't changed (using NSURLRequestReloadRevalidatingCacheData already limits downloading, but we're still always parsing the old data)
* Use https://github.com/mattt/AnyJSON
* Add tests


## Apps using RemoteConfig
* Last.fm Scrobbler
* MetroLyrics
* Radio.com
* Tailgate Fan

Are you using RemoteConfig in your iOS or Mac OS X app? Send a pull request with an updated README.md file to be included.


## License
RemoteConfig is available under the MIT license. See the LICENSE file for more info.
