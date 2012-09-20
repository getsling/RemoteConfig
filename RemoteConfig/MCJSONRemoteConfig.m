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
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [MCJSONUtilities parseJSONResultString:dataString error:&error];

    if (error) {
        NSLog(@"Parse error: %@", [error localizedDescription]);
    }

    return dict;
}

@end
