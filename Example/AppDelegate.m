//
//  AppDelegate.m
//  RemoteConfig
//
//  Created by Kevin Renskers on 24-05-12.
//  Copyright (c) 2012 Gangverk. All rights reserved.
//

#import "AppDelegate.h"
#import "Config.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[Config sharedInstance] registerSuccessBlock:^{
        NSLog(@"This should never be the local default (\"Default local value\"): %@", [Config sharedInstance].exampleStringValue);
    } failureBlock:^(NSError *error) {
        NSLog(@"Download failure: %@", [error localizedDescription]);
    }];

    return YES;
}
							
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Without this code RemoteConfig will never redownload the newest remote file if
    // the app is never ever killed.
    if ([[Config sharedInstance] needsToDownloadRemoteFile]) {
        [[Config sharedInstance] downloadRemoteFile];
    }
}

@end
