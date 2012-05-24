//
//  Config.m
//  RemoteConfig
//
//  Created by Kevin Renskers on 23-05-12.
//  Copyright (c) 2012 Kevin Renskers. All rights reserved.
//

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
    [self mapRemoteKeyPath:@"rate_app_after" toLocalAttribute:@"rateAppAfter" defaultValue:[NSNumber numberWithInteger:99]];
    [self mapRemoteKeyPath:@"rate_app_url" toLocalAttribute:@"rateAppUrl" defaultValue:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=323701765"];
}

@end
