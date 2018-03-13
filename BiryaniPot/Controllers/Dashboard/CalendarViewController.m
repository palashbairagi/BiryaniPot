//
//  CalendarViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 2/9/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _datePicker = [SSMaterialCalendarPicker initCalendarOn:self.view withDelegate:self];
    [_datePicker showAnimated];
}

-(void)rangeSelectedWithStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd YYYY"];
    [_fromDateDelegate setTitle:[NSString stringWithFormat:@"%@", [formatter stringFromDate:startDate]] forState:UIControlStateNormal] ;
    [_toDateDelegate setTitle:[NSString stringWithFormat:@"%@", [formatter stringFromDate:endDate]] forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSDate *)convertToDateFromString:(NSString *)current
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd YYYY"];
    NSDate *date = [dateFormat dateFromString:current];
    return date;
}

@end
