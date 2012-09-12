//
//  MCBaseRemoteConfig.m
//  RemoteConfig
//
//  Created by Kevin Renskers on 23-05-12.
//  Copyright (c) 2012 Kevin Renskers. All rights reserved.
//

#import "MCBaseRemoteConfig.h"

static NSString *const MCRemoteConfigNSUserDefaultsKeyConfig = @"nl.mixedCase.RemoteConfig.config";
static NSString *const MCRemoteConfigNSUserDefaultsKeyLastDownload = @"nl.mixedCase.RemoteConfig.lastDownload";
NSString *const MCRemoteConfigStatusChangedNotification = @"nl.mixedCase.RemoteConfig.statusChangedNotification";

@interface MCBaseRemoteConfig ()

@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSMutableDictionary *mapping;
@property (copy, nonatomic) MCRemoteConfigCompletionSuccessBlock successBlock;
@property (copy, nonatomic) MCRemoteConfigCompletionFailureBlock failureBlock;

// Private methods
- (void)loadConfig;
- (BOOL)needsToDownloadRemoteFile;
- (void)applyMapping:(NSDictionary *)parsedData;
- (void)statusChanged:(MCRemoteConfigStatusEnum)status;

@end


@implementation MCBaseRemoteConfig

@synthesize MCRemoteConfigStatus = _MCRemoteConfigStatus;
@synthesize receivedData = _receivedData;
@synthesize mapping = _mapping;
@synthesize successBlock = _successBlock;
@synthesize failureBlock = _failureBlock;

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

- (void)executeBlockWhenDownloaded:(MCRemoteConfigCompletionSuccessBlock)successBlock onFailure:(MCRemoteConfigCompletionFailureBlock)failureBlock {
    if (self.MCRemoteConfigStatus == kMCRemoteConfigStatusUsingLocalConfig || self.MCRemoteConfigStatus == kMCRemoteConfigStatusUsingRemoteConfig) {
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
    NSDictionary *parsedData = [[NSUserDefaults standardUserDefaults] objectForKey:MCRemoteConfigNSUserDefaultsKeyConfig];
    if (parsedData != nil) {
        [self applyMapping:parsedData];
        [self statusChanged:kMCRemoteConfigStatusUsingLocalConfig];

        // If there is a block waiting, then execute it.
        if (self.successBlock) {
            self.successBlock();
            self.successBlock = nil;
        }
    }
}

- (BOOL)needsToDownloadRemoteFile {
    NSDate *lastdownload = [[NSUserDefaults standardUserDefaults] objectForKey:MCRemoteConfigNSUserDefaultsKeyLastDownload];
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
    if (self.MCRemoteConfigStatus == kMCRemoteConfigStatusDownloading) {
        // We're already downloading
        return;
    }

    [self statusChanged:kMCRemoteConfigStatusDownloading];
    NSURLRequest *request = [NSURLRequest requestWithURL:[self remoteFileLocation] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:50];
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

- (void)statusChanged:(MCRemoteConfigStatusEnum)status {
    self.MCRemoteConfigStatus = status;
    [[NSNotificationCenter defaultCenter] postNotificationName:MCRemoteConfigStatusChangedNotification object:self];
}

#pragma mark - Overriden in JSONRemoteConfig and XMLRemoteConfig

- (NSDictionary *)parseDownloadedData:(NSData *)data {
    NSAssert(NO, @"JSONRemoteconfig and XMLRemoteConfig subclasses need to overwrite this method");
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

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    [self statusChanged:kMCRemoteConfigStatusDownloadFailed];

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
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:MCRemoteConfigNSUserDefaultsKeyLastDownload];

    // Save the NSDictionary to NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:parsedData forKey:MCRemoteConfigNSUserDefaultsKeyConfig];
    [[NSUserDefaults standardUserDefaults] synchronize];

    // Apply the mapping as given by [setupMapping]
    [self applyMapping:parsedData];
    [self statusChanged:kMCRemoteConfigStatusUsingRemoteConfig];

    // If there is a block waiting, then execute it.
    if (self.successBlock) {
        self.successBlock();
        self.successBlock = nil;
    }
}

@end
