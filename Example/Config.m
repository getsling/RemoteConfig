//
//  Config.m
//  RemoteConfig
//
//  Created by Kevin Renskers on 23-05-12.
//  Copyright (c) 2012 Kevin Renskers. All rights reserved.
//

#import "Config.h"

@implementation Config

@synthesize exampleIntegerValue = _exampleIntegerValue;
@synthesize exampleStringValue = _exampleStringValue;

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
    [self mapRemoteKeyPath:@"remote_integer_value" toLocalAttribute:@"exampleIntegerValue" defaultValue:[NSNumber numberWithInteger:1]];
    [self mapRemoteKeyPath:@"remote_string_value" toLocalAttribute:@"exampleStringValue" defaultValue:@"Default local value"];
}

@end
