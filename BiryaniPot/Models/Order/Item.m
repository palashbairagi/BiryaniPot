//
//  Item.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/30/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "Item.h"

@implementation Item

-(id)copyWithZone:(NSZone *)zone
{
    Item *item = [[[self class] allocWithZone:zone] init];
    if(item) {
        item.itemId = _itemId;
        item.categoryId = _categoryId;
        item.name = _name;
        item.price = _price;
        item.isVeg = _isVeg;
        item.isSpiceSupported = _isSpiceSupported;
        item.discount = _discount;
        item.imageURL = _imageURL;
        item.image = _image;
        item.detail = _detail;
        item.quantity = _quantity;
        item.spiceLevel = _spiceLevel;
        item.itemTypeId = _itemTypeId;
    }
    
    return item;
}

@end
