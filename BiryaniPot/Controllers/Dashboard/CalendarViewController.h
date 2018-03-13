//
//  CalendarViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 2/9/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSMaterialCalendarPicker/SSMaterialCalendarPicker.h>
#import <SSMaterialCalendarPicker/NSDate+SSDateAdditions.h>

@interface CalendarViewController : UIViewController <SSMaterialCalendarPickerDelegate>
@property (nonatomic, retain) SSMaterialCalendarPicker *datePicker;
@property (nonatomic, retain) UIButton* fromDateDelegate;
@property (nonatomic, retain) UIButton* toDateDelegate;
@end
