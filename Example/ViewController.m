//
//  ViewController.m
//  RemoteConfig
//
//  Created by Kevin Renskers on 24-05-12.
//  Copyright (c) 2012 Kevin Renskers. All rights reserved.
//

#import "ViewController.h"
#import "Config.h"

NSString *const MCRemoteConfigStatusStrings[] = {
    @"Using defaults\n", 
    @"Using locally saved config\n", 
    @"Downloading\n", 
    @"Download failed\n", 
    @"Using remote config\n"
};

@implementation ViewController

@synthesize integerLabel = _integerLabel;
@synthesize stringLabel = _stringLabel;
@synthesize statusLabel = _statusLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusChanged:) name:MCRemoteConfigStatusChangedNotification object:nil];
    self.integerLabel.text = [NSString stringWithFormat:@"%@", [Config config].exampleIntegerValue];
    self.stringLabel.text = [Config config].exampleStringValue;
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MCRemoteConfigStatusChangedNotification object:nil];
    [self setIntegerLabel:nil];
    [self setStatusLabel:nil];
    [self setStringLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)refreshLabels {
    self.integerLabel.text = [NSString stringWithFormat:@"%@", [Config config].exampleIntegerValue];
    self.stringLabel.text = [Config config].exampleStringValue;
}

- (IBAction)forceDownload {
    [[Config config] downloadRemoteFile];
}

- (void)statusChanged:(NSNotification *)notification {
    Config *config = notification.object;
    self.statusLabel.text = [self.statusLabel.text stringByAppendingString:MCRemoteConfigStatusStrings[config.MCRemoteConfigStatus]];
}

@end
