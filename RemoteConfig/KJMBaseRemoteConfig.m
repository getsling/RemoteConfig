//
//  BaseRemoteConfig.m
//  metrolyrics
//
//  Created by Kevin Renskers on 23-05-12.
//  Copyright (c) 2012 Gangverk. All rights reserved.
//

#import "KJMBaseRemoteConfig.h"


@interface KJMBaseRemoteConfig ()

@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSMutableDictionary *mapping;

// Private methods
- (BOOL)needsToDownloadRemoteFile;
- (void)downloadRemoteFile;
- (void)applyMapping:(id)parsedData;

@end


@implementation KJMBaseRemoteConfig

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
        if ([self needsToDownloadRemoteFile]) {
            [self setupMapping]; // also loads default values
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
    return YES;
}

- (void)downloadRemoteFile {
    NSURLRequest *request = [NSURLRequest requestWithURL:[self remoteFileLocation] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if (connection) {
        self.receivedData = [NSMutableData data];
    }
}

- (void)applyMapping:(id)parsedData {
    for (NSString *keyPath in self.mapping) {
        NSString *attribute = [self.mapping objectForKey:keyPath];
        [self setValue:[parsedData valueForKeyPath:keyPath] forKey:attribute];
    }
}

#pragma mark - Overriden in JSONRemoteConfig and XMLRemoteConfig

- (id)parseDownloadedData:(NSData *)data {
    NSAssert(NO, @"JSONRemoteconfig and XMLRemoteConfig subclasses need to overwrite this method");
    return nil;
}

#pragma mark - Override in your own class

- (NSURL *)remoteFileLocation {
    NSAssert(NO, @"Your own subclass needs to overwrite this method");
    return nil;
}

- (NSString *)localFileLocation {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"config.plist"];
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
    id parsedData = [self parseDownloadedData:self.receivedData];
    [self applyMapping:parsedData];
}

@end
