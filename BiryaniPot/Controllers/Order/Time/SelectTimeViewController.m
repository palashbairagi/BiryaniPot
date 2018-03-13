//
//  SelectTimeViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/21/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "SelectTimeViewController.h"

@interface SelectTimeViewController ()

@end

@implementation SelectTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.yesButton.layer.cornerRadius = 5;
    self.yesButton.layer.borderWidth = 1;
    self.yesButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient1 = [CAGradientLayer layer];
    gradient1.frame = CGRectMake(0, 0, 80, 30);
    gradient1.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient1.locations = @[@(0), @(1)];gradient1.startPoint = CGPointMake(0.5, 0);
    gradient1.endPoint = CGPointMake(0.5, 1);
    gradient1.cornerRadius = 5;
    [[self.yesButton layer] addSublayer:gradient1];
    
    _timeArray = [[NSMutableArray alloc]init];
    
    for (int i=1; i<25; i++)
    {
        [_timeArray addObject:[NSString stringWithFormat:@"%d min", i*5]];
    }
}

- (IBAction)noButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)yesButtonClicked:(id)sender
{
    [_delegate.timeRequired setTitle:[_timeArray objectAtIndex:[_timePicker selectedRowInComponent:0]] forState:UIControlStateNormal];
    
    [_delegate.timeRequired setTitle:[_timeArray objectAtIndex:[_timePicker selectedRowInComponent:0]] forState:UIControlStateHighlighted];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 24;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _timeArray[row];
}
@end
