//
//  ViewController.m
//  RemoteConfig
//
//  Created by Kevin Renskers on 24-05-12.
//  Copyright (c) 2012 Kevin Renskers. All rights reserved.
//

#import "ViewController.h"
#import "Config.h"

@implementation ViewController

@synthesize valueLabel = _valueLabel;
@synthesize statusLabel = _statusLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.valueLabel.text = [NSString stringWithFormat:@"%@", [Config config].exampleValue];
}

- (void)viewDidUnload {
    [self setValueLabel:nil];
    [self setStatusLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)refreshValue {
    self.valueLabel.text = [NSString stringWithFormat:@"%@", [Config config].exampleValue];
}

@end
