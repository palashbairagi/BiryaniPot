//
//  Category.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/27/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Category : NSObject
@property (nonatomic, retain) NSString *categoryId;
@property (nonatomic, retain) NSString *categoryName;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSString *isNonVeg;
@property (nonatomic,strong) UIImage *image ;
@end
