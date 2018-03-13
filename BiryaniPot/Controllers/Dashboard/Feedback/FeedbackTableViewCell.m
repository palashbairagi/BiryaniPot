//
//  FeedbackTableViewCell.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/9/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "FeedbackTableViewCell.h"

@implementation FeedbackTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(Feedback *)feedback
{
    self.orderNo.text = feedback.orderNo;
    self.contactNumber.text = feedback.contactNumber;
    
    if (feedback.email != (id)[NSNull null])self.email.text = feedback.email;
    else self.email.text = @"";
    
    self.isPaid.text = feedback.paymentType;
    
    if (feedback.amount != (id)[NSNull null])self.amount.text = feedback.amount;
    else self.amount.text = @"";
    
    if (feedback.smiley == (id)[NSNull null])
    {
        self.smiley.text = @"";
    }
    else if ([feedback.smiley isEqualToString:@"Good"])
    {
        self.smiley.text = [NSString stringWithFormat:@"%C", 0xf118];
        [_smiley setTextColor:[UIColor greenColor]];
    }
    else
    {
        self.smiley.text = [NSString stringWithFormat:@"%C", 0xf119];
        [_smiley setTextColor:[UIColor orangeColor]];
    }
    
    
    
}

@end
