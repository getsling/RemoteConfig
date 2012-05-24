//
//  MCXMLRemoteConfig.m
//  RemoteConfig
//
//  Created by Kevin Renskers on 23-05-12.
//  Copyright (c) 2012 Kevin Renskers. All rights reserved.
//

#import "MCXMLRemoteConfig.h"
#import "MCXMLReader.h"

@implementation MCXMLRemoteConfig

- (NSDictionary *)parseDownloadedData:(NSData *)data {
    NSError *error = nil;
    return [MCXMLReader dictionaryForXMLData:data error:&error];
}

@end
