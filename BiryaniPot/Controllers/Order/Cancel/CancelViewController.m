//
//  CancelViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/29/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "CancelViewController.h"

@interface CancelViewController ()

@end

@implementation CancelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _orderNo.text = _order.orderNo;
    _customerName.text = _order.customerName;
}

- (IBAction)yesButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)noButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
