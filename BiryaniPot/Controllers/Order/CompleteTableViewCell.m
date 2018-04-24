//
//  DeliveredTableViewCell.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/27/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "CompleteTableViewCell.h"

@implementation CompleteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.checkIconButton setTitle:[NSString stringWithFormat:@"%C", 0xf058] forState:UIControlStateNormal];

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
}

- (IBAction)checkIconButtonClicked:(id)sender
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *notification = [NSNotification notificationWithName:@"OrderEnteringPreparingStage" object: self];
    [notificationCenter postNotification:notification];
}

@end
