//
//  GVJSONRemoteConfig.m
//  RemoteConfig
//
//  Created by Kevin Renskers on 23-05-12.
//  Copyright (c) 2012 Gangverk. All rights reserved.
//

#import "GVJSONRemoteConfig.h"
#import "GVJSONUtilities.h"

@implementation GVJSONRemoteConfig

- (NSDictionary *)parseDownloadedData:(NSData *)data {
    NSError *error = nil;
    NSDictionary *dict = JSONDecode(data, &error);

    if (error) {
        NSLog(@"Parse error: %@", [error localizedDescription]);
    }

    return dict;
}

@end
