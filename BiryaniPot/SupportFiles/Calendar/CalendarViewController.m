//
//  CalendarViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 2/9/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "CalendarViewController.h"
#import "RangePickerCell.h"
#import "Validation.h"

@interface CalendarViewController ()

@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

// The start date of the range
@property (strong, nonatomic) NSDate *date1;
// The end date of the range
@property (strong, nonatomic) NSDate *date2;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectButton.layer.cornerRadius = 5;
    self.selectButton.layer.borderWidth = 1;
    self.selectButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, _selectButton.layer.bounds.size.width, _selectButton.layer.bounds.size.height);
    gradient.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient.locations = @[@(0), @(1)];gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    gradient.cornerRadius = 5;[[self.selectButton layer] addSublayer:gradient];
    
    _calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, _calendarView.layer.bounds.size.width, _calendarView.layer.bounds.size.height)];
    _calendar.dataSource = self;
    _calendar.delegate = self;
    _calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    _calendar.swipeToChooseGesture.enabled = YES;
    _calendar.today = nil;
    _calendar.pagingEnabled = NO;
    _calendar.allowsMultipleSelection = YES;
    _calendar.rowHeight = 50;
    _calendar.appearance.headerTitleColor = [UIColor blackColor];
    _calendar.appearance.weekdayTextColor = [UIColor blackColor];
    _calendar.accessibilityIdentifier = @"calendar";
    _gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateFormat = @"MMM dd yyyy";
    _calendar.accessibilityIdentifier = @"calendar";
    
    [_calendarView addSubview:_calendar];
    [_calendar registerClass:[RangePickerCell class] forCellReuseIdentifier:@"cell"];
    
    _date1 = [self convertStringToDate:_fromDateDelegate.currentTitle];
    _date2 = [self convertStringToDate:_toDateDelegate.currentTitle];
    
    [_waitView removeFromSuperview];
    [_activityIndicator removeFromSuperview];
    
}

#pragma mark - FSCalendarDataSource

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    if (_disablePastDates)
    {
        return [[NSDate alloc]init];
    }
    return nil;
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    if (_disableFutureDates)
    {
        return [[NSDate alloc]init];
    }
    return nil;
}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    RangePickerCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:monthPosition];
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition
{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

#pragma mark - FSCalendarDelegate

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return NO;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    
    if (calendar.swipeToChooseGesture.state == UIGestureRecognizerStateChanged) {
        // If the selection is caused by swipe gestures
        if (!self.date1) {
            self.date1 = date;
        } else {
            if (self.date2) {
                [calendar deselectDate:self.date2];
            }
            self.date2 = date;
        }
    } else {
        if (self.date2) {
            [calendar deselectDate:self.date1];
            [calendar deselectDate:self.date2];
            self.date1 = date;
            self.date2 = nil;
        } else if (!self.date1) {
            self.date1 = date;
        } else {
            self.date2 = date;
        }
    }
    
    [self configureVisibleCells];
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did deselect date %@",[self.dateFormatter stringFromDate:date]);
    [self configureVisibleCells];
}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @[[UIColor orangeColor]];
    }
    return @[appearance.eventDefaultColor];
}

#pragma mark - Private methods

- (void)configureVisibleCells
{
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendar dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
}

- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position
{
    RangePickerCell *rangeCell = cell;
    if (position != FSCalendarMonthPositionCurrent) {
        rangeCell.middleLayer.hidden = YES;
        rangeCell.selectionLayer.hidden = YES;
        return;
    }
    if (self.date1 && self.date2) {
        // The date is in the middle of the range
        BOOL isMiddle = [date compare:self.date1] != [date compare:self.date2];
        rangeCell.middleLayer.hidden = !isMiddle;
    } else {
        rangeCell.middleLayer.hidden = YES;
    }
    BOOL isSelected = NO;
    isSelected |= self.date1 && [self.gregorian isDate:date inSameDayAsDate:self.date1];
    isSelected |= self.date2 && [self.gregorian isDate:date inSameDayAsDate:self.date2];
    rangeCell.selectionLayer.hidden = !isSelected;
}

- (IBAction)selectButtonClicked:(id)sender
{
    if ([_calendar selectedDates].count != 0 )
    {
        NSDate *startDate = [_calendar selectedDates][0];
        NSDate *endDate = [_calendar selectedDates][[_calendar selectedDates].count-1];
        
        if([startDate compare:endDate] == NSOrderedDescending)
        {
            NSDate *temp = startDate;
            startDate = endDate;
            endDate = temp;
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM dd yyyy"];
        
        [_fromDateDelegate setTitle:[NSString stringWithFormat:@"%@", [formatter stringFromDate:startDate]] forState:UIControlStateNormal] ;
        [_toDateDelegate setTitle:[NSString stringWithFormat:@"%@", [formatter stringFromDate:endDate]] forState:UIControlStateNormal];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.didDismiss)
        self.didDismiss();
    
}

-(NSDate *)convertStringToDate:(NSString *)current
{
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd yyyy"];
    NSDate *dateFromString = [dateFormatter dateFromString:current];
    
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|
                               NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|
                               NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday fromDate:dateFromString];
    [comps setHour:12];
    [comps setMinute:00];
    [comps setSecond:00];
    [comps setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

@end

