//
//  SearchTableViewCell.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/12/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellData:(Order *)order
{
    _orderNo.text = order.orderNo;
    _itemCount.text = order.itemCount;
    _customerName.text = order.customerName;
    _contactNumber.text = order.contactNumber;
    _status.text = order.status;
}

@end
