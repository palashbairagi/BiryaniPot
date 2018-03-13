//
//  Constants.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/5/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

+(NSString *)changeDateFormatForAPI:(NSString *)currentDate;

+(NSString *) LOCATION_ID;
+(NSString *) GET_TODAY_DATE;
+(NSString *) GET_FIFTEEN_DAYS_AGO_DATE;
+(NSString *) LOGIN_URL;
+(NSString *) FOOTER_STATISTICS_URL;

/* Dashboard */
+(NSString *) TOTAL_ORDER_URL;
+(NSString *) TOTAL_ORDER_LIST_URL;
+(NSString *) TOP_SELLERS_URL;
+(NSString *) FEEDBACK_URL;
+(NSString *) OFFER_URL;
+(NSString *) OFFER_STATISTICS_URL;
+(NSString *) GRAPH_URL;

/* Restaurant Profile */
+(NSString *) GET_RESTAURANT_PROFILE_URL;
+(NSString *) UPDATE_RESTAURANT_PROFILE_URL;
+(NSString *) GET_RESTAURANT_TIME_URL;
+(NSString *) UPDATE_RESTAURANT_TIME_URL;

/* My Profile */
+(NSString *) GET_MY_PROFILE_URL;

/* User Management */
+(NSString *) GET_DELIVERY_PERSON_URL;
+(NSString *) GET_MANAGER_URL;
+(NSString *) DELETE_DELIVERY_PERSON_URL;
+(NSString *) DELETE_MANAGER_URL;

/* Promo Code */
+(NSString *) GET_OFFERS_URL;

/* Menu */
+(NSString *) GET_CATEGORY_ON_SETTING_URL;
+(NSString *) GET_ITEM_ON_SETTING_URL;

/* Landing Pages */
+(NSString *) GET_LANDING_PAGES_URL;

/* Orders */
+(NSString *) GET_ALL_ORDERS_URL;
+(NSString *) GET_ITEMS_BY_ORDER_URL;
+(NSString *) UPDATE_ORDER_STATUS_URL;

/* Menu */
+(NSString *) GET_CATEGORIES_URL;
+(NSString *) GET_ITEMS_BY_CATEGORY_URL;

@end
