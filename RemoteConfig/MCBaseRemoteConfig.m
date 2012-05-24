//
//  MCBaseRemoteConfig.m
//  RemoteConfig
//
//  Created by Kevin Renskers on 23-05-12.
//  Copyright (c) 2012 Kevin Renskers. All rights reserved.
//

#import "MCBaseRemoteConfig.h"

static NSString * const kMCRemoteConfigNSUserDefaultsKey = @"nl.mixedCase.RemoteConfig.config";


@interface MCBaseRemoteConfig ()

@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSMutableDictionary *mapping;

// Private methods
- (BOOL)needsToDownloadRemoteFile;
- (void)downloadRemoteFile;
- (void)applyMapping:(NSDictionary *)parsedData;

@end


@implementation MCBaseRemoteConfig

@synthesize receivedData = _receivedData;
@synthesize mapping = _mapping;

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
        if ([self needsToDownloadRemoteFile]) { // if available, loads locally saved values
            [self downloadRemoteFile];
        }
    }
    
    return self;
}

- (void)dealloc {
    // save class to disk
}

- (void)mapRemoteKeyPath:(NSString *)keyPath toLocalAttribute:(NSString *)attribute defaultValue:(id)defaultValue {
    [self.mapping setObject:attribute forKey:keyPath];
    [self setValue:defaultValue forKey:attribute];
}

#pragma mark - Private methods

- (BOOL)needsToDownloadRemoteFile {
    // Was the config already saved into NSUserDefaults?
    NSDictionary *parsedData = [[NSUserDefaults standardUserDefaults] objectForKey:kMCRemoteConfigNSUserDefaultsKey];
    if (parsedData != nil) {
        [self applyMapping:parsedData];
        return NO;

        // TODO: should check how old the saved data is, maybe we have to download the config file again.
        // Or, use the last modified header or something like that?
    }

    return YES;
}

- (void)downloadRemoteFile {
    NSURLRequest *request = [NSURLRequest requestWithURL:[self remoteFileLocation] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if (connection) {
        self.receivedData = [NSMutableData data];
    }
}

- (void)applyMapping:(NSDictionary *)parsedData {
    for (NSString *keyPath in self.mapping) {
        NSString *attribute = [self.mapping objectForKey:keyPath];
        [self setValue:[parsedData valueForKeyPath:keyPath] forKey:attribute];
    }
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

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Parse the NSData into a NSDictionary (responsabiliy of a subclass)
    NSDictionary *parsedData = [self parseDownloadedData:self.receivedData];

    // Save the NSDictionary to NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:parsedData forKey:kMCRemoteConfigNSUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    // Apply the mapping as given by [setupMapping]
    [self applyMapping:parsedData];
}

@end
