//
//  Order.h
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 12/27/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject
@property (nonatomic, retain) NSString *orderNo;
@property (nonatomic, retain) NSString *customerName;
@property (nonatomic, retain) NSString *contactNumber;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *itemCount;
@property (nonatomic, retain) NSString *orderTime;
@property (nonatomic, retain) NSString *timeRemain;
@property (nonatomic, retain) NSString *outTime;
@property (nonatomic, retain) NSString *deliveryPerson;
@property (nonatomic, retain) NSString *deliveryPersonURL;
@property (nonatomic, retain) NSString *deliveryType;
@property (nonatomic, retain) NSString *deliveryFee;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *grandTotal;
@property (nonatomic, retain) NSString *tax;
@property (nonatomic, retain) NSString *subTotal;
@property (nonatomic, retain) NSString *tip;
@property (nonatomic, retain) NSString *paymentType;
@end
