//
//  SelectTimeViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/21/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderViewController.h"
#import "Order.h"

@interface SelectTimeViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;
@property (nonatomic, retain) NSMutableArray *timeArray;
@property (nonatomic, retain) OrderViewController *delegate;
@property (nonatomic, retain) Order *order;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@end
