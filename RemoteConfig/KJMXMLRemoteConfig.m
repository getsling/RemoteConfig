//
//  KJMXMLRemoteConfig.m
//  metrolyrics
//
//  Created by Kevin Renskers on 23-05-12.
//  Copyright (c) 2012 Gangverk. All rights reserved.
//

#import "KJMXMLRemoteConfig.h"
#import "KJMXMLReader.h"

@implementation KJMXMLRemoteConfig

- (id)parseDownloadedData:(NSData *)data {
    NSError *error = nil;
    return [KJMXMLReader dictionaryForXMLData:data error:&error];
}

@end
