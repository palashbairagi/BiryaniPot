//
//  OrderDetailViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/29/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface OrderDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *contactNumber;
@property (weak, nonatomic) IBOutlet UILabel *customerName;
@property (weak, nonatomic) IBOutlet UILabel *billAmount;
@property (weak, nonatomic) IBOutlet UIButton *addItemButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITableView *itemTable;
@property (nonatomic, retain) NSMutableArray *itemArray;

@property (nonatomic, retain) Order *order;

@end
