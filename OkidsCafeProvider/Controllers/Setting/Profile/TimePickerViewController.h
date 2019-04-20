//
//  TimePickerViewController.h
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 12/28/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "ProfileViewController.h"

@interface TimePickerViewController : UIViewController <NSURLSessionDelegate>
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (nonatomic, retain) NSDateFormatter *timeFormat;
@property (nonatomic, retain) NSString *time;
@property(nonatomic,assign)UIButton *buttonClicked;
@property(nonatomic,retain)ProfileViewController *delegate;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end
