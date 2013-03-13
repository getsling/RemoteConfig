//
//  GVBaseRemoteConfig.h
//  RemoteConfig
//
//  Created by Kevin Renskers on 23-05-12.
//  Copyright (c) 2012 Gangverk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kGVRemoteConfigStatusUsingDefaults,
    kGVRemoteConfigStatusUsingLocalConfig,
    kGVRemoteConfigStatusDownloading,
    kGVRemoteConfigStatusDownloadFailed,
    kGVRemoteConfigStatusUsingRemoteConfig
} GVRemoteConfigStatusEnum;

extern NSString *const GVRemoteConfigStatusChangedNotification;

typedef void (^GVRemoteConfigCompletionSuccessBlock)();
typedef void (^GVRemoteConfigCompletionFailureBlock)(NSError *error);

@interface GVBaseRemoteConfig : NSObject <NSURLConnectionDelegate>

@property (nonatomic) GVRemoteConfigStatusEnum GVRemoteConfigStatus;

// Public methods
- (void)mapRemoteKeyPath:(NSString *)keyPath toLocalAttribute:(NSString *)attribute defaultValue:(id)defaultValue;
- (BOOL)needsToDownloadRemoteFile;
- (void)downloadRemoteFile;
- (void)executeBlockWhenDownloaded:(GVRemoteConfigCompletionSuccessBlock)successBlock onFailure:(GVRemoteConfigCompletionFailureBlock)failureBlock;

// Overriden in GVJSONRemoteConfig and GVXMLRemoteConfig
- (NSDictionary *)parseDownloadedData:(NSData *)data;

// Override in your own class
- (NSURL *)remoteFileLocation;
- (void)setupMapping;
- (NSTimeInterval)redownloadRate;
- (NSTimeInterval)timeoutInterval;
- (NSString *)defaultsKeyStoredValues;
- (NSString *)defaultsKeyLastDownload;

@end
