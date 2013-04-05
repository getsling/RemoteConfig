//
//  ViewController.m
//  RemoteConfig
//
//  Created by Kevin Renskers on 24-05-12.
//  Copyright (c) 2012 Gangverk. All rights reserved.
//

#import "ViewController.h"
#import "Config.h"

NSString *const GVRemoteConfigStatusStrings[] = {
    @"Using defaults\n", 
    @"Using locally saved config\n", 
    @"Downloading\n", 
    @"Download failed\n", 
    @"Using remote config\n"
};


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *integerLabel;
@property (weak, nonatomic) IBOutlet UILabel *stringLabel;
@property (weak, nonatomic) IBOutlet UITextView *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *nonExistingLabel;

- (IBAction)refreshLabels;
- (IBAction)forceDownload;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusChanged:) name:GVRemoteConfigStatusChangedNotification object:nil];
    self.integerLabel.text = [NSString stringWithFormat:@"%@", [Config sharedInstance].exampleIntegerValue];
    self.stringLabel.text = [Config sharedInstance].exampleStringValue;
    self.nonExistingLabel.text = [Config sharedInstance].nonExistingStringValue;

    [[Config sharedInstance] executeBlockWhenDownloaded:^{
        // This is always a downloaded (or saved) version, not the locally defined default value
        NSLog(@"This should never be the local default (\"Default local value\"): %@", [Config sharedInstance].exampleStringValue);
    } onFailure:^(NSError *error) {
        NSLog(@"Download failure: %@", [error localizedDescription]);
    }];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GVRemoteConfigStatusChangedNotification object:nil];
    [self setIntegerLabel:nil];
    [self setStatusLabel:nil];
    [self setStringLabel:nil];
    [self setNonExistingLabel:nil];
    [super viewDidUnload];
}

- (IBAction)refreshLabels {
    self.integerLabel.text = [NSString stringWithFormat:@"%@", [Config sharedInstance].exampleIntegerValue];
    self.stringLabel.text = [Config sharedInstance].exampleStringValue;
    self.nonExistingLabel.text = [Config sharedInstance].nonExistingStringValue;
}

- (IBAction)forceDownload {
    [[Config sharedInstance] downloadRemoteFile];
}

- (void)statusChanged:(NSNotification *)notification {
    Config *config = notification.object;
    self.statusLabel.text = [self.statusLabel.text stringByAppendingString:GVRemoteConfigStatusStrings[config.GVRemoteConfigStatus]];
}

@end
