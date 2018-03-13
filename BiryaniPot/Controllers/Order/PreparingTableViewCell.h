//
//  PreparingTableViewCell.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/27/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "OrderViewController.h"

@interface PreparingTableViewCell : UITableViewCell <NSURLSessionDelegate>

@property (nonatomic, retain) OrderViewController *delegate;

@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *customerName;
@property (weak, nonatomic) IBOutlet UILabel *timeRemain;
@property (weak, nonatomic) IBOutlet UILabel *itemCount;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (nonatomic, retain) NSString *deliveryPerson;

- (void)setCellData:(Order *)order;

@end
