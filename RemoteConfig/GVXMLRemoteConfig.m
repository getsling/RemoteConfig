//
//  GVXMLRemoteConfig.m
//  RemoteConfig
//
//  Created by Kevin Renskers on 23-05-12.
//  Copyright (c) 2012 Gangverk. All rights reserved.
//

#import "GVXMLRemoteConfig.h"
#import "GVXMLReader.h"

@implementation GVXMLRemoteConfig

- (NSDictionary *)parseDownloadedData:(NSData *)data {
    NSError *error = nil;
    return [GVXMLReader dictionaryForXMLData:data error:&error];
}

@end
