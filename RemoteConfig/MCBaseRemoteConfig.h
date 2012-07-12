//
//  MCBaseRemoteConfig.h
//  RemoteConfig
//
//  Created by Kevin Renskers on 23-05-12.
//  Copyright (c) 2012 Kevin Renskers. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kMCRemoteConfigStatusUsingDefaults,
    kMCRemoteConfigStatusUsingLocalConfig,
    kMCRemoteConfigStatusDownloading,
    kMCRemoteConfigStatusDownloadFailed,
    kMCRemoteConfigStatusUsingRemoteConfig
} MCRemoteConfigStatusEnum;

extern NSString *const MCRemoteConfigStatusChangedNotification;

typedef void (^MCRemoteConfigCompletionBlock)();

@interface MCBaseRemoteConfig : NSObject <NSURLConnectionDelegate>

@property (nonatomic) MCRemoteConfigStatusEnum MCRemoteConfigStatus;

// Public methods
- (void)mapRemoteKeyPath:(NSString *)keyPath toLocalAttribute:(NSString *)attribute defaultValue:(id)defaultValue;
- (void)downloadRemoteFile;
- (void)executeBlockWhenDownloaded:(MCRemoteConfigCompletionBlock)block;

// Overriden in JSONRemoteConfig and XMLRemoteConfig
- (NSDictionary *)parseDownloadedData:(NSData *)data;

// Override in your own class
- (NSURL *)remoteFileLocation;
- (void)setupMapping;
- (NSTimeInterval)redownloadRate;

@end
