//
//  MCJSONRemoteConfig.m
//  RemoteConfig
//
//  Created by Kevin Renskers on 23-05-12.
//  Copyright (c) 2012 Kevin Renskers. All rights reserved.
//

#import "MCJSONRemoteConfig.h"
#import "MCJSONUtilities.h"

@implementation MCJSONRemoteConfig

- (NSDictionary *)parseDownloadedData:(NSData *)data {
    NSError *error = nil;
    return JSONDecode(data, &error);
}

@end
