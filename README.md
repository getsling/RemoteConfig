# RemoteConfig
Objective-c library for loading a remote JSON / XML config file with locally defined default values.


## Installation
1. Get the code: `git clone git://github.com/kevinrenskers/RemoteConfig.git`
2. Drag the `RemoteConfig` subfolder to your project. Check both "copy items into destination group's folder" and your target.

Alternatively you can add this code as a Git submodule:

1. `cd [your project root]`
2. `git submodule add git://github.com/kevinrenskers/RemoteConfig.git`
3. Drag the `RemoteConfig` subfolder to your project. Uncheck the "copy items into destination group's folder" box, do check your target.

However you get the code, you need to do one extra step:

1. In your project settings go to the build fases. In the "compile sources" section add the `-fno-objc-arc` flag to `MCJSONUtilities.m`.


## How to get started
Create a subclass of `MCJSONRemoteConfig` or `MCXMLRemoteConfig` and override the following methods:

* `- (NSURL *)remoteFileLocation;` (required)
* `- (void)setupMapping;` (required)
* `- (void)statusChanged:(MCRemoteConfigStatus)status;` (optional)
* `- (NSTimeInterval)redownloadRate;` (optional, by default the remote file is redownloaded every 24 hours)

It's recommended to add synthesized properties for your config values. However, key value coding also works.


### Example
See the included example app: `Config.m` and `ViewController.m`.


## Requirements

### JSON
RemoteConfig uses [`NSJSONSerialization`](http://developer.apple.com/library/mac/#documentation/Foundation/Reference/NSJSONSerialization_Class/Reference/Reference.html) for JSON files, if it is available. If your app targets a platform where this class is not available (iOS < 5.0) you can include one of the following JSON libraries to your project for RemoteConfig to automatically detect and use.

* [JSONKit](https://github.com/johnezang/JSONKit)
* [SBJson](https://stig.github.com/json-framework/)
* [YAJL](https://lloyd.github.com/yajl/)
* [NextiveJson](https://github.com/nextive/NextiveJson)

If you're not using JSON based config files, you don't need to include any of them.

### ARC Support
RemoteConfig requires ARC support and should run on iOS 4.0 and higher. However, `MCJSONUtilities.m` needs to be compiled with the `-fno-objc-arc` flag. To do this in Xcode, go to your active target and select the "Build Phases" tab. In the "Compiler Flags" column, set `-fno-objc-arc` for `MCJSONUtilities.m`.


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

* [AFNetworking](https://github.com/AFNetworking/AFNetworking/) for the `MCJSONUtilities` wrapper around multiple JSON libraries.
* [XML-to-NSDictionary](https://github.com/Coeur/XML-to-NSDictionary) for the `MCXMLReader` class.


## License
RemoteConfig is available under the MIT license. See the LICENSE file for more info.
