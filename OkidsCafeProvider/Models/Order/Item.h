//
//  Item.h
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 12/30/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Item : NSObject <NSCopying>
@property (nonatomic, retain) NSString *itemId;
@property (nonatomic, retain) NSString *categoryId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *price;
@property (nonatomic) BOOL isVeg;
@property (nonatomic) BOOL isSpiceSupported;
@property (nonatomic, retain) NSString *discount;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *detail;
@property (nonatomic, retain) NSString *quantity;
@property (nonatomic, retain) NSString *spiceLevel;
@property (nonatomic, retain) NSString *itemTypeId;
@property (nonatomic, retain) NSString *pointsRequired;
@end
