//
//  Constants.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/5/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "Constants.h"

@implementation Constants

static NSString *BASE_URL = @"http://74.208.161.174/BiryaniPotAPI/";
static NSString *PROVIDER_BASE_URL = @"http://74.208.161.174/Provider-WS/";

+(NSString *)changeDateFormatForAPI: (NSString *) currentDate
{
    NSString *convertedDate = @"";
    @try
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd yyyy"];
        NSDate *date = [dateFormatter dateFromString:currentDate];
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
        [dateFormatter1 setDateFormat:@"yyyy-mm-dd"];
        
        convertedDate = [dateFormatter1 stringFromDate:date];
    }
    @catch(NSException *e)
    {
        NSLog(@"%@ %@", e.name, e.reason);
    }
    return convertedDate;
}

+(NSString *)LOCATION_ID
{
    return @"1";
}

+(NSString *)GET_TODAY_DATE
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd yyyy"];
    
    NSString *todayDate = [dateFormatter stringFromDate:[NSDate date]];
    return todayDate;
}

+(NSString *)GET_FIFTEEN_DAYS_AGO_DATE
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd yyyy"];
    
    NSDate *now = [NSDate date];
    NSDate *fifteenDaysAgo = [now dateByAddingTimeInterval:-15*24*60*60];
    
    NSString *fifteenDaysAgoDate = [dateFormatter stringFromDate:fifteenDaysAgo];
    return fifteenDaysAgoDate;
}

+(NSString *)LOGIN_URL
{
    return [NSString stringWithFormat:@"%@rest/services/authentication/superuser",BASE_URL];
}

+(NSString *) FOOTER_STATISTICS_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/footerstatistics",BASE_URL];
}

/* Dashboard */

+(NSString *) TOTAL_ORDER_URL
{
    return [NSString stringWithFormat:@"%@rest/Provider/getTotalOrders", PROVIDER_BASE_URL];
}

+(NSString *) TOP_SELLERS_URL
{
    return [NSString stringWithFormat:@"%@rest/Provider/getTopSellers", PROVIDER_BASE_URL];
}

+(NSString *) FEEDBACK_URL
{
    return [NSString stringWithFormat:@"%@rest/Provider/getFeedback", PROVIDER_BASE_URL];
}

+(NSString *) GRAPH_URL
{
    return [NSString stringWithFormat:@"%@rest/Provider/getTrendChart", PROVIDER_BASE_URL];
}

/* My Profile */
+(NSString *) GET_MY_PROFILE_URL
{
    return [NSString stringWithFormat:@"%@rest/services/user/userprofile", BASE_URL];
}

/* Restaurant Profile */
+(NSString *) GET_RESTAURANT_PROFILE_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/restaurant", BASE_URL];
}

+(NSString *) UPDATE_RESTAURANT_PROFILE_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/updaterestaurant", BASE_URL];
}

+(NSString *) GET_RESTAURANT_TIME_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/getrestauranttimings", BASE_URL];
}

+(NSString *) UPDATE_RESTAURANT_TIME_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/updaterestauranttimings", BASE_URL];
}

/* User Management */

+(NSString *) GET_DELIVERY_PERSON_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/deliveryboys", BASE_URL];
}

+(NSString *) GET_MANAGER_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/managers", BASE_URL];
}

+(NSString *) DELETE_MANAGER_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/deletemanager", BASE_URL];
}

+(NSString *) DELETE_DELIVERY_PERSON_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/updatedeliveryboys", BASE_URL];
}

/* Offer */

+(NSString *) GET_OFFERS_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/promocodes", BASE_URL];
}

/* Menu */

+(NSString *) GET_CATEGORY_ON_SETTING_URL
{
    return [NSString stringWithFormat:@"%@rest/menu/getCategoryList", PROVIDER_BASE_URL];
}

+(NSString *) GET_ITEM_ON_SETTING_URL
{
    return [NSString stringWithFormat:@"%@rest/menu/getItemSearchByCat", PROVIDER_BASE_URL];
}

/* Landing Pages */

+(NSString *) GET_LANDING_PAGES_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/images", BASE_URL];
}

/* Order */

+(NSString *) GET_ALL_ORDERS_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/orders", BASE_URL];
}

+(NSString *) GET_ITEMS_BY_ORDER_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/orderdetails", BASE_URL];
}

+(NSString *) UPDATE_ORDER_STATUS_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/processorder", BASE_URL];
}

/* Menu */

+(NSString *) GET_CATEGORIES_URL
{
    return [NSString stringWithFormat:@"%@rest/services/menu/category", BASE_URL];
}

+(NSString *) GET_ITEMS_BY_CATEGORY_URL
{
    return [NSString stringWithFormat:@"%@rest/services/menu/items", BASE_URL];
}

@end
