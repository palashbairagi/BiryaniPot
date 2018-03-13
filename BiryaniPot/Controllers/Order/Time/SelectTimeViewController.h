//
//  SelectTimeViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/21/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueueTableViewCell.h"

@interface SelectTimeViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;
@property (nonatomic, retain) NSMutableArray *timeArray;
@property (nonatomic, retain) QueueTableViewCell *delegate;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@end
