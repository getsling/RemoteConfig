//
//  MCBaseRemoteConfig.h
//  RemoteConfig
//
//  Created by Kevin Renskers on 23-05-12.
//  Copyright (c) 2012 Kevin Renskers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCBaseRemoteConfig : NSObject <NSURLConnectionDelegate>

// Public methods
- (void)mapRemoteKeyPath:(NSString *)keyPath toLocalAttribute:(NSString *)attribute defaultValue:(id)defaultValue;

// Overriden in JSONRemoteConfig and XMLRemoteConfig
- (id)parseDownloadedData:(NSData *)data;

// Override in your own class
- (NSURL *)remoteFileLocation;
- (NSString *)localFileLocation;
- (void)setupMapping;

@end
