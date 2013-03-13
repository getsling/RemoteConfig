//
//  GVBaseRemoteConfig.m
//  RemoteConfig
//
//  Created by Kevin Renskers on 23-05-12.
//  Copyright (c) 2012 Gangverk. All rights reserved.
//

#import "GVBaseRemoteConfig.h"

NSString *const GVRemoteConfigStatusChangedNotification = @"is.gangverk.RemoteConfig.statusChangedNotification";

@interface GVBaseRemoteConfig ()

@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSMutableDictionary *mapping;
@property (copy, nonatomic) GVRemoteConfigCompletionSuccessBlock successBlock;
@property (copy, nonatomic) GVRemoteConfigCompletionFailureBlock failureBlock;

// Private methods
- (void)loadConfig;
- (BOOL)needsToDownloadRemoteFile;
- (void)applyMapping:(NSDictionary *)parsedData;
- (void)statusChanged:(GVRemoteConfigStatusEnum)status;

@end


@implementation GVBaseRemoteConfig

#pragma mark - Setters and getters

- (NSMutableDictionary *)mapping {
    if (!_mapping) _mapping = [NSMutableDictionary dictionary];
    return _mapping;
}

#pragma mark - Public methods

- (id)init {
    self = [super init];
    if (self) {
        [self setupMapping]; // also loads default values
        [self loadConfig]; // loads locally saved values
        if ([self needsToDownloadRemoteFile]) {
            [self downloadRemoteFile];
        }
    }
    
    return self;
}

- (void)mapRemoteKeyPath:(NSString *)keyPath toLocalAttribute:(NSString *)attribute defaultValue:(id)defaultValue {
    [self.mapping setObject:attribute forKey:keyPath];
    [self setValue:defaultValue forKey:attribute];
}

- (void)executeBlockWhenDownloaded:(GVRemoteConfigCompletionSuccessBlock)successBlock onFailure:(GVRemoteConfigCompletionFailureBlock)failureBlock {
    if (self.GVRemoteConfigStatus == kGVRemoteConfigStatusUsingLocalConfig || self.GVRemoteConfigStatus == kGVRemoteConfigStatusUsingRemoteConfig) {
        // We're already using the downloaded or saved value, so execute the block
        successBlock();
    } else {
        self.successBlock = successBlock;
        self.failureBlock = failureBlock;
        [self downloadRemoteFile];
    }
}

#pragma mark - Private methods

- (void)loadConfig {
    // Was the config already saved into NSUserDefaults?
    NSDictionary *parsedData = [[NSUserDefaults standardUserDefaults] objectForKey:[self defaultsKeyStoredValues]];
    if (parsedData != nil) {
        [self applyMapping:parsedData];
        [self statusChanged:kGVRemoteConfigStatusUsingLocalConfig];

        // If there is a block waiting, then execute it.
        if (self.successBlock) {
            self.successBlock();
            self.successBlock = nil;
        }
    }
}

- (BOOL)needsToDownloadRemoteFile {
    NSDate *lastdownload = [[NSUserDefaults standardUserDefaults] objectForKey:[self defaultsKeyLastDownload]];
    if (lastdownload == nil) {
        // If the remote file has never been download, then we need to download it for sure
        return YES;
    }

    NSTimeInterval rate = [self redownloadRate];
    if (rate) {
        NSDate *rateTimeAgo = [NSDate dateWithTimeIntervalSinceNow:-(rate)];
        NSComparisonResult result = [lastdownload compare:rateTimeAgo];
        if (result == NSOrderedAscending) {
            // (now-rate) is greater then last download time, so we need to redownload
            return YES;
        }
    }

    return NO;
}

- (void)downloadRemoteFile {
    if (self.GVRemoteConfigStatus == kGVRemoteConfigStatusDownloading) {
        // We're already downloading
        return;
    }

    [self statusChanged:kGVRemoteConfigStatusDownloading];
    NSURLRequest *request = [NSURLRequest requestWithURL:[self remoteFileLocation] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:[self timeoutInterval]];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if (connection) {
        self.receivedData = [NSMutableData data];
    }
}

- (void)applyMapping:(NSDictionary *)parsedData {
    for (NSString *keyPath in self.mapping) {
        NSString *attribute = [self.mapping objectForKey:keyPath];
        id value = [parsedData valueForKeyPath:keyPath];
        if (value != nil) {
            [self setValue:value forKey:attribute];
        }
    }
}

- (void)statusChanged:(GVRemoteConfigStatusEnum)status {
    self.GVRemoteConfigStatus = status;
    [[NSNotificationCenter defaultCenter] postNotificationName:GVRemoteConfigStatusChangedNotification object:self];
}

#pragma mark - Overriden in GVJSONRemoteConfig and GVXMLRemoteConfig

- (NSDictionary *)parseDownloadedData:(NSData *)data {
    NSAssert(NO, @"GVJSONRemoteconfig and GVXMLRemoteConfig subclasses need to overwrite this method");
    return nil;
}

#pragma mark - Override in your own class

- (NSURL *)remoteFileLocation {
    NSAssert(NO, @"Your own subclass needs to overwrite this method");
    return nil;
}

- (void)setupMapping {
    NSAssert(NO, @"Your own subclass needs to overwrite this method");
}

- (NSTimeInterval)redownloadRate {
    // By default we redownload the remote config file once every 24 hours
    // Return 0 if you always want to download the file
    return 60*60*24;
}

- (NSTimeInterval)timeoutInterval {
    // By default we timeout the request at 30 seconds
    return 30;
}

- (NSString *)defaultsKeyStoredValues {
    return @"is.gangverk.RemoteConfig.config";
}

- (NSString *)defaultsKeyLastDownload {
    return @"is.gangverk.RemoteConfig.lastDownload";
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    [self statusChanged:kGVRemoteConfigStatusDownloadFailed];

    // If there is a block waiting, then execute it.
    if (self.failureBlock) {
        self.failureBlock(error);
        self.failureBlock = nil;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Parse the NSData into a NSDictionary (responsibility of a subclass)
    NSDictionary *parsedData = [self parseDownloadedData:self.receivedData];

    if (!parsedData) {
        NSLog(@"No parsedData found");
    }

    // Save the date of the last download
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:[self defaultsKeyLastDownload]];

    // Save the NSDictionary to NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:parsedData forKey:[self defaultsKeyStoredValues]];
    [[NSUserDefaults standardUserDefaults] synchronize];

    // Apply the mapping as given by [setupMapping]
    [self applyMapping:parsedData];
    [self statusChanged:kGVRemoteConfigStatusUsingRemoteConfig];

    // If there is a block waiting, then execute it.
    if (self.successBlock) {
        self.successBlock();
        self.successBlock = nil;
    }
}

@end
