//
//  DeliveredTableViewCell.h
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 12/27/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "OrderViewController.h"

@interface CompleteTableViewCell : UITableViewCell

@property (nonatomic, retain) OrderViewController *delegate;

@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *customerName;
@property (weak, nonatomic) IBOutlet UILabel *itemCount;
@property (weak, nonatomic) IBOutlet UIButton *checkIconButton;

- (void)setCellData:(Order *)order;

@end
