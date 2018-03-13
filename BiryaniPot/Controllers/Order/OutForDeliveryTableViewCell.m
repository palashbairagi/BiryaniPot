//
//  OutForDeliveryTableViewCell.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/27/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "OutForDeliveryTableViewCell.h"

@implementation OutForDeliveryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.checkIconButton setTitle:[NSString stringWithFormat:@"%C", 0xf015] forState:UIControlStateNormal];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithRed:1 green:0.98 blue:0.67 alpha:1]];
    [self setSelectedBackgroundView:bgColorView];
}

-(void)setCellData:(Order *)order
{
    _orderNo.text = order.orderNo;
    _outTime.text = order.outTime;
    _itemCount.text = order.itemCount;
    _customerName.text = order.customerName;
    _deliveryPerson.text = order.deliveryPerson;
}

- (IBAction)checkIconButtonClicked:(id)sender
{
    
}


@end
