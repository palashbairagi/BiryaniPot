//
//  CalendarViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 2/9/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FSCalendar.h>

@interface CalendarViewController : UIViewController <FSCalendarDelegate, FSCalendarDataSource>

@property (nonatomic, copy) void (^didDismiss)(void);

@property IBOutlet UIView *waitView;
@property IBOutlet UIActivityIndicatorView *activityIndicator;

@property FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIView *calendarView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (nonatomic, retain) UIButton* fromDateDelegate;
@property (nonatomic, retain) UIButton* toDateDelegate;

@property bool disablePastDates;
@property bool disableFutureDates;

@property UIViewController *delegate;

@end
