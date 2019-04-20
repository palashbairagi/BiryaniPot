//
//  Print.h
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 7/12/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "Order.h"

@interface Print : NSObject
@property (nonatomic, retain) Order *order;
@property (nonatomic, retain) NSArray *itemArray;
@end
