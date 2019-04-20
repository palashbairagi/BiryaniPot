//
//  TotalOrdersTableViewCell.m
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 1/9/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "TotalOrdersTableViewCell.h"
#import "InvoiceViewController.h"

@implementation TotalOrdersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(Feedback *)totalOrders
{
    if (totalOrders.email != (id)[NSNull null])self.email.text = totalOrders.email;
    else self.email.text = @"";
    
    self.orderNo.text = totalOrders.orderNo;
    self.type.text = totalOrders.orderType;
    self.contactNumber.text = totalOrders.contactNumber;
    self.isPaid.text = totalOrders.paymentType;
    
    if (totalOrders.amount != (id)[NSNull null])self.amount.text = totalOrders.amount;
    else self.amount.text = @"";
}

- (IBAction)invoiceButtonClicked:(id)sender {
    InvoiceViewController *invoiceViewController = [[InvoiceViewController alloc]init];
    invoiceViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    invoiceViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    invoiceViewController.preferredContentSize = CGSizeMake(520, 650);
    invoiceViewController.delegate = _delegate.totalOrderArray[_invoiceButton.tag]; 
    
    [self.delegate presentViewController:invoiceViewController animated:YES completion:nil];
}

@end
