//
//  SearchTableViewCell.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/12/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "OrderViewController.h"

@interface SearchTableViewCell : UITableViewCell <NSURLSessionDelegate>

@property (nonatomic, retain) OrderViewController *delegate;

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *customerName;
@property (weak, nonatomic) IBOutlet UILabel *itemCount;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *contactNumber;

- (void)setCellData:(Order *)order;

@end
