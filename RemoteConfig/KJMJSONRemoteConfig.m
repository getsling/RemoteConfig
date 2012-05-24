//
//  JSONRemoteConfig.m
//  metrolyrics
//
//  Created by Kevin Renskers on 23-05-12.
//  Copyright (c) 2012 Gangverk. All rights reserved.
//

#import "KJMJSONRemoteConfig.h"
#import "KJMJSONUtilities.h"

@implementation KJMJSONRemoteConfig

- (id)parseDownloadedData:(NSData *)data {
    NSError *error = nil;
    return JSONDecode(data, &error);
}

@end
