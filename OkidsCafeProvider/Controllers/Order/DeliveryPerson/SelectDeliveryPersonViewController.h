//
//  SelectDeliveryPersonViewController.h
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 1/22/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreparingTableViewCell.h"
#import "Order.h"
#import "OrderViewController.h"

@interface SelectDeliveryPersonViewController : UIViewController <NSURLSessionDelegate ,UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, retain) OrderViewController *delegate;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) NSMutableArray *nameArray;
@property (nonatomic, retain) Order *order;

@end
