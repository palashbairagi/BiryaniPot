//
//  Offer.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/28/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

@interface Offer : NSObject
@property (nonatomic, retain) NSString * offerId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * offerValue;
@property (nonatomic, retain) UIImage * image;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * startFrom;
@property (nonatomic, retain) NSString * endAt;
@property (nonatomic, retain) NSString * maxDisc;
@property (nonatomic, retain) NSString * maxTimes;
@property (nonatomic, retain) NSString * minValue;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSString * maxUsageLimit;
@property (nonatomic, retain) NSString * timesApplied;
@property (nonatomic, retain) NSString * isPercent;
@end
