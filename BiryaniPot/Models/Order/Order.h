//
//  Order.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/27/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject
@property (nonatomic, retain) NSString *orderNo;
@property (nonatomic, retain) NSString *customerName;
@property (nonatomic, retain) NSString *contactNumber;
@property (nonatomic, retain) NSString *itemCount;
@property (nonatomic, retain) NSString *orderTime;
@property (nonatomic, retain) NSString *timeRemain;
@property (nonatomic, retain) NSString *outTime;
@property (nonatomic, retain) NSString *deliveryPerson;
@property (nonatomic, retain) NSString *deliveryType;
@property (nonatomic, retain) NSString *status;

@end
