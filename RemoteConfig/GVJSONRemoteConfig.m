//
//  GVJSONRemoteConfig.m
//  RemoteConfig
//
//  Created by Kevin Renskers on 23-05-12.
//  Copyright (c) 2012 Gangverk. All rights reserved.
//

#import "GVJSONRemoteConfig.h"

@implementation GVJSONRemoteConfig

- (NSDictionary *)parseDownloadedData:(NSData *)data {
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data options:9 error:&error];

    if (error) {
        NSLog(@"Parse error: %@", [error localizedDescription]);
        return nil;
    }

    if ([object isKindOfClass:[NSDictionary class]]) {
        return object;
    }

    return nil;
}

@end
