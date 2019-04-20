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
    Item *item;
    int quantity;
    
    if (_addItemDelegate != NULL)
    {
        item = _addItemDelegate.itemArray1[_negativeButton.tag];
    }
    else
    {
        item = _delegate.updatedItemArray[_negativeButton.tag];
    }
    
    quantity = [item.quantity intValue];
    
    if(!(_delegate.isQueue))
    {
        BOOL found = FALSE;
        Item *updatedItem;
        
        for (int i = 0; i < _delegate.itemArray.count; i++)
        {
            updatedItem = _delegate.itemArray[i];
            
            if ([updatedItem.itemId intValue] == [item.itemId intValue])
            {
                found = TRUE;
                break;
            }
        }
        
        if (found)
        {
            if([updatedItem.quantity intValue] >= quantity)
            {
                if (_addItemDelegate == NULL)
                    [Validation showSimpleAlertOnViewController:_delegate withTitle:@"Alert" andMessage:@"Item is preparing, cannot perform the selected action"];
                else
                    [Validation showSimpleAlertOnViewController:_addItemDelegate withTitle:@"Alert" andMessage:@"Item is preparing, cannot perform the selected action"];
                
                return;
            }
        }
    }
    
    if ([_quantity.text intValue] > 0)
    {
        _quantity.text = [NSString stringWithFormat:@"%d",[_quantity.text intValue]-1];
        
        item = _delegate.updatedItemArray[_negativeButton.tag];
        item.quantity = _quantity.text;
        
        _price.text = [NSString stringWithFormat:@"$%.2f", ([item.price floatValue] * [item.quantity intValue])];
        
        if (_addItemDelegate == NULL)
        {
            [_delegate getTotal];
        }
    }
    
} 

- (IBAction)positiveButtonClicked:(id)sender
{
    Item *item;
    long index = 0;
    
    _quantity.text = [NSString stringWithFormat:@"%d",[_quantity.text intValue]+1];
    
    if(_addItemDelegate != NULL)
    {
        item = _addItemDelegate.itemArray1[_positiveButton.tag];
        index = [_delegate.updatedItemArray indexOfObject:item];
    }
    else
    {
        item = _delegate.updatedItemArray[_positiveButton.tag];
    }
    
    item.quantity = _quantity.text;
    _price.text = [NSString stringWithFormat:@"$%.2f", ([item.price floatValue] * [item.quantity intValue])];
    
    if(_addItemDelegate != NULL)
    {
        if(NSNotFound == index)
        {
            [_delegate.updatedItemArray addObject:item];
        }
        else
        {
            _delegate.updatedItemArray[index] = item;
        }
        
        _addItemDelegate.revisedItemTotal.text = [NSString stringWithFormat:@"$%.2f", [_delegate getTotal]];
    }
    else
    {
        _delegate.updatedItemArray[_positiveButton.tag] = item;
        [_delegate getTotal];
    }
    
}

- (IBAction)spiceLevelChanged:(UISegmentedControl *)sender
{
    long index = sender.selectedSegmentIndex;
    
    Item *item;
    int quantity;
    
    if (_addItemDelegate != NULL)
    {
        item = _addItemDelegate.itemArray1[sender.tag];
    }
    else
    {
        item = _delegate.updatedItemArray[sender.tag];
    }
    
    quantity = [item.quantity intValue];
    
    if (quantity < 1)
    {
        return;
    }
    
    if (index == 0)
    {
        item.spiceLevel = @"Low";
    }
    else if (index == 1)
    {
        item.spiceLevel = @"Medium";
    }
    else if (index == 2)
    {
        item.spiceLevel = @"High";
    }
}


-(void)setCellData:(Item *)item isQueue:(BOOL)isQueue isPreparing:(BOOL)isPreparing
{
    _name.text = item.name;
    
    if (item.quantity != nil)
    {
        _quantity.text = item.quantity;
    }
    else
    {
        _quantity.text = @"0";
    }
    
    _price.text = [NSString stringWithFormat:@"$%.2f", ([item.price floatValue] * [item.quantity intValue])];
    
    if (item.isSpiceSupported)
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
    
    // Uncomment it to implement update order
//    if (isQueue || isPreparing)
//    {
//        _negativeButton.hidden = FALSE;
//        _positiveButton.hidden = FALSE;
//    }
//    else
//    {
        _negativeButton.hidden = TRUE;
        _positiveButton.hidden = TRUE;
        _quantityView.layer.borderColor = [UIColor clearColor].CGColor;
 //   }
    
}

@end
