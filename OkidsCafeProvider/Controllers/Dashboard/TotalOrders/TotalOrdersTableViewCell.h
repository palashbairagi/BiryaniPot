//
//  TotalOrdersTableViewCell.h
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 1/9/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feedback.h"
#import "TotalOrdersViewController.h"

@interface TotalOrdersTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *contactNumber;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *isPaid;
@property (weak, nonatomic) IBOutlet UIButton *invoiceButton;

@property (nonatomic, retain) TotalOrdersViewController *delegate;

- (void)setCellData:(Feedback *)totalOrders;

@end
