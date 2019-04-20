//
//  Feeback.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/9/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feedback : NSObject
@property (nonatomic, retain) NSString *orderNo;
@property (nonatomic, retain) NSString *orderDate;
@property (nonatomic, retain) NSString *orderType;
@property (nonatomic, retain) NSString *amount;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *contactNumber;
@property (nonatomic, retain) NSString *paymentType;
@property (nonatomic, retain) NSString *smiley;
@property (nonatomic, retain) NSString *tip;
@end
