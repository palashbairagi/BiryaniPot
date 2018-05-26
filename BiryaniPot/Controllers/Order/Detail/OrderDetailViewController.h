//
//  OrderDetailViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/29/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "OrderViewController.h"

@interface OrderDetailViewController : UIViewController <NSURLSessionDelegate ,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, retain) OrderViewController *delegate;

@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *itemCount;

@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *contactNumber;
@property (weak, nonatomic) IBOutlet UILabel *customerName;
@property (weak, nonatomic) IBOutlet UILabel *subTotal;
@property (weak, nonatomic) IBOutlet UILabel *deliveryFee;
@property (weak, nonatomic) IBOutlet UILabel *tip;
@property (weak, nonatomic) IBOutlet UILabel *tax;
@property (weak, nonatomic) IBOutlet UILabel *deliveryType;

@property (weak, nonatomic) IBOutlet UILabel *grandTotal;

@property (weak, nonatomic) IBOutlet UIButton *addItemButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITableView *itemTable;
@property (nonatomic, retain) NSMutableArray *itemArray;

@property (nonatomic, retain) Order *order;

@property BOOL isQueue;
@property BOOL isPreparing;

@end
