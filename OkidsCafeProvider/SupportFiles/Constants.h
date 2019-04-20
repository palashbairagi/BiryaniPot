//
//  Constants.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/5/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MRProgress/MRProgressOverlayView+AFNetworking.h>
#import "Print.h"

#if DEBUG == 1
#define DebugLog(...)
#elif DEBUG == 1
#define DebugLog(...) NSLog(__VA_ARGS__)
#endif

@interface Constants : NSObject

+(NSString *)changeDateFormatForAPI:(NSString *)currentDate;

+(NSString *) LOCATION_ID;
+(NSString *) ORGANIZATION_ID;
+(NSString *) MENU_ID;
+(NSString *) ACCESS_TOKEN;
+(NSString *) GET_LOCATION_DETAILS;

#pragma mark - Date
+(NSString *) GET_TODAY_DATE;
+(NSString *) GET_FIFTEEN_DAYS_AGO_DATE;
+(NSString *) GET_FIFTEEN_DAYS_FROM_NOW_DATE;
+(NSString *) GET_DASHBOARD_FROM_DATE;
+(NSString *) GET_DASHBOARD_TO_DATE;
+(void) SET_DASHBOARD_FROM_DATE:(NSString *)fromDate;
+(void) SET_DASHBOARD_TO_DATE:(NSString *)toDate;

#pragma mark - Login
+(NSString *) APP_SETTING_URL;
+(NSString *) LOGIN_URL;
+(NSString *)FORGOT_PASSWORD_URL;
+(NSString *)GET_PASSWORD_URL;

#pragma mark - Dashboard
+(NSString *) TOTAL_ORDER_URL;
+(NSString *) TOTAL_ORDER_LIST_URL;
+(NSString *) TOP_SELLERS_URL;
+(NSString *) FEEDBACK_URL;
+(NSString *) FEEDBACK_TAG_URL;
+(NSString *) FEEDBACK_BY_USER_URL;
+(NSString *) FEEDBACK_REPLY_URL;
+(NSString *) OFFER_URL;
+(NSString *) OFFER_STATISTICS_URL;
+(NSString *) GRAPH_URL;

#pragma mark - Restaurant Profile
+(NSString *) GET_RESTAURANT_PROFILE_URL;
+(NSString *) UPDATE_RESTAURANT_PROFILE_URL;
+(NSString *) GET_RESTAURANT_TIME_URL;
+(NSString *) UPDATE_RESTAURANT_TIME_URL;
+(NSString *) GET_TAX_URL;
+(NSString *) UPDATE_TAX_URL;

#pragma mark - User
+(NSString *) GET_DELIVERY_PERSON_URL;
+(NSString *) GET_MANAGER_URL;
+(NSString *) DELETE_DELIVERY_PERSON_URL;
+(NSString *) DELETE_MANAGER_URL;
+(NSString *) INSERT_DELIVERY_PERSON_URL;
+(NSString *) INSERT_MANAGER_URL;

#pragma mark - Offers
+(NSString *) GET_OFFERS_URL;
+(NSString *) INSERT_OFFER_URL;
+(NSString *) UPDATE_OFFER_URL;

#pragma mark - Landing Images
+(NSString *) GET_LANDING_PAGES_URL;
+(NSString *) UPDATE_LANDING_IMAGE;

#pragma mark - Order
+(NSString *) GET_ALL_ORDERS_URL;
+(NSString *) GET_ITEMS_BY_ORDER_URL;
+(NSString *) UPDATE_ORDER_DETAIL;
+(NSString *) UPDATE_ORDER_STATUS_URL;
+(NSString *) UPDATE_ESTIMATED_TIME_URL;
+(NSString *) ASSIGN_DELIVERY_PERSON_URL;
+(NSString *) CANCEL_ORDER_URL;
+(NSString *) FOOTER_STATISTICS_URL;

#pragma mark - Menu
+(NSString *) GET_CATEGORIES_URL;
+(NSString *) GET_ITEMS_BY_CATEGORY_URL;
+(NSString *) INSERT_CATEGORY_URL;
+(NSString *) UPDATE_CATEGORY_URL;
+(NSString *) DELETE_CATEGORY_URL;
+(NSString *) INSERT_ITEM_URL;
+(NSString *) UPDATE_ITEM_URL;
+(NSString *) DELETE_ITEM_URL;
+(NSString *) GET_RECOMMENDED_ITEMS_URL;
+(NSString *) ADD_RECOMMENDED_ITEMS_URL;
+(NSString *) REMOVE_RECOMMENDED_ITEMS_URL;

#pragma mark - Profile
+(NSString *) CHANGE_PASSWORD;
+(NSString *) UPDATE_PROFILE;

#pragma mark - print
+(void) printInvoice: (Print *)print;

#pragma mark - Payment
+(NSString *) CARD_CONNECT_BASE_URL;
+(NSString *) AUTHORIZATION_STRING;
+(NSString *) REFUND_URL;
+(NSString *) GET_PAYMENT_DETAIL_URL;

@end
