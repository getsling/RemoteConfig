//
//  ViewController.h
//  RemoteConfig
//
//  Created by Kevin Renskers on 24-05-12.
//  Copyright (c) 2012 Kevin Renskers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *integerLabel;
@property (weak, nonatomic) IBOutlet UILabel *stringLabel;
@property (weak, nonatomic) IBOutlet UITextView *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *nonExistingLabel;

- (IBAction)refreshLabels;
- (IBAction)forceDownload;

@end
