//
//  InvoiceViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 2/9/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feedback.h"
#import "Order.h"
#import "Constants.h"

@interface InvoiceViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *customerName;
@property (weak, nonatomic) IBOutlet UILabel *customerPhone;
@property (weak, nonatomic) IBOutlet UILabel *orderDate;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UILabel *subTotal;
@property (weak, nonatomic) IBOutlet UILabel *deliveryFee;
@property (weak, nonatomic) IBOutlet UILabel *tax;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UILabel *deliveryType;
@property (weak, nonatomic) IBOutlet UILabel *tip;
@property (weak, nonatomic) IBOutlet UILabel *paymentType;

@property (nonatomic, retain) NSMutableArray *itemArray;
@property (nonatomic, retain) Feedback *delegate;
@property (nonatomic, retain) Order *order;

@end
