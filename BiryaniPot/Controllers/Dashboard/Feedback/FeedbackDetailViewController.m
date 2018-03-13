//
//  FeedbackDetailViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 2/10/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "FeedbackDetailViewController.h"

@interface FeedbackDetailViewController ()

@end

@implementation FeedbackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sendButton.layer.cornerRadius = 5;
    self.sendButton.layer.borderWidth = 1;
    self.sendButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient1 = [CAGradientLayer layer];
    gradient1.frame = CGRectMake(0, 0, 100, 40);
    gradient1.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient1.locations = @[@(0), @(1)];gradient1.startPoint = CGPointMake(0.5, 0);
    gradient1.endPoint = CGPointMake(0.5, 1);
    gradient1.cornerRadius = 5;
    [[self.sendButton layer] addSublayer:gradient1];
    
}

- (IBAction)closeButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
