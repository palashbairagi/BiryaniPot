//
//  OutForDeliveryTableViewCell.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/27/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "OrderViewController.h"

@interface OutForDeliveryTableViewCell : UITableViewCell

@property (nonatomic, retain) OrderViewController *delegate;

@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *customerName;
@property (weak, nonatomic) IBOutlet UILabel *itemCount;
@property (weak, nonatomic) IBOutlet UILabel *outTime;
@property (weak, nonatomic) IBOutlet UIButton *checkIconButton;
@property (weak, nonatomic) IBOutlet UILabel *deliveryPerson;
@property (weak, nonatomic) IBOutlet UIImageView *dboyImage;
@property (nonatomic, retain) NSOperationQueue *dboyQueue ;

- (void)setCellData:(Order *)order;

@end
