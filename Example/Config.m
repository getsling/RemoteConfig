//
//  Config.m
//  RemoteConfig
//
//  Created by Kevin Renskers on 23-05-12.
//  Copyright (c) 2012 Gangverk. All rights reserved.
//

#import "Config.h"

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
