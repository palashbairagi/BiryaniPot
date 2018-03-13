//
//  Offer.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/28/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Offer : NSObject
@property (nonatomic, retain) NSString * offerId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * startFrom;
@property (nonatomic, retain) NSString * endAt;
@property (nonatomic, retain) NSString * maxDisc;
@property (nonatomic, retain) NSString * maxTimes;
@property (nonatomic, retain) NSString * minValue;
@property (nonatomic, retain) NSString * detail;

@end
