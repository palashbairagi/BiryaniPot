//
//  OrderDetailTableViewCell.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/29/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "OrderDetailTableViewCell.h"

@implementation OrderDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)negativeButtonClicked:(id)sender
{
    if(!_delegate.isQueue)
    {
        [Validation showSimpleAlertOnViewController:_delegate withTitle:@"Alert" andMessage:@"Item is preparing, cannot perform the selected action"];
        return;
    }
    
    if ([_quantity.text intValue] > 0)
    {
        _quantity.text = [NSString stringWithFormat:@"%d",[_quantity.text intValue]-1];
    }
}

- (IBAction)positiveButtonClicked:(id)sender
{
    _quantity.text = [NSString stringWithFormat:@"%d",[_quantity.text intValue]+1];
}

-(void)setCellData:(Item *)item isQueue:(BOOL)isQueue isPreparing:(BOOL)isPreparing
{
    _name.text = item.name;
    _quantity.text = item.quantity;
    _price.text = [NSString stringWithFormat:@"$%.2f", ([item.price floatValue] * [item.quantity intValue])];
    
    if (isQueue)
    {
        _spiceView.hidden = FALSE;
        
        if(item.spiceLevel == NULL)
        {
            [_spiceLevel setSelectedSegmentIndex:UISegmentedControlNoSegment];
        }
        else if([item.spiceLevel isEqualToString:@"Low"])
        {
            [_spiceLevel setSelectedSegmentIndex:0];
        }
        else if([item.spiceLevel isEqualToString:@"Medium"])
        {
            [_spiceLevel setSelectedSegmentIndex:1];
        }
        else if([item.spiceLevel isEqualToString:@"High"])
        {
            [_spiceLevel setSelectedSegmentIndex:2];
        }
        
    }
    else
    {
        _spiceView.hidden = TRUE;
    }
    
    if (isQueue || isPreparing)
    {
        _negativeButton.hidden = FALSE;
        _positiveButton.hidden = FALSE;
    }
    else
    {
        _negativeButton.hidden = TRUE;
        _positiveButton.hidden = TRUE;
        _quantityView.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
}

@end
