//
//  DeliveredTableViewCell.m
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 12/27/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "CompleteTableViewCell.h"

@implementation CompleteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
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
    _itemCount.text = [NSString stringWithFormat:@"%@ Items", order.itemCount];
    _customerName.text = order.customerName;
    
    if ([order.status isEqualToString:@"Delivered"])
    {
        [self.checkIconButton setTitle:[NSString stringWithFormat:@"%C", 0xf015] forState:UIControlStateNormal];
    }
    else
    {
        [self.checkIconButton setTitle:[NSString stringWithFormat:@"%C", 0xf058] forState:UIControlStateNormal];
    }
}

@end
