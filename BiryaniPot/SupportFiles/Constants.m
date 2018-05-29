//
//  Constants.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/5/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "Constants.h"
#import "AppDelegate.h"

@implementation Constants
static NSString * fromDate;
static NSString * toDate;

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
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
        
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
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return [appDelegate.userDefaults objectForKey:@"locationId"];
}

+(NSString *) ORGANIZATION_ID
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return [appDelegate.userDefaults objectForKey:@"organizationId"];
}

+(NSString *) MENU_ID
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return [appDelegate.userDefaults objectForKey:@"menuId"];
}

#pragma mark - Date
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

+(NSString *)GET_FIFTEEN_DAYS_FROM_NOW_DATE
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd yyyy"];
    
    NSDate *now = [NSDate date];
    NSDate *fifteenDaysFromNow = [now dateByAddingTimeInterval:15*24*60*60];
    
    NSString *fifteenDaysFromNowDate = [dateFormatter stringFromDate:fifteenDaysFromNow];
    return fifteenDaysFromNowDate;
}

+(NSString *) GET_DASHBOARD_FROM_DATE
{
    return fromDate;
}

+(NSString *) GET_DASHBOARD_TO_DATE
{
    return toDate;
}

+(void) SET_DASHBOARD_FROM_DATE:(NSString *)dashboardDate
{
    fromDate = dashboardDate;
}

+(void) SET_DASHBOARD_TO_DATE:(NSString *)dashboardDate
{
    toDate = dashboardDate;
}

#pragma mark - Login

+(NSString *) APP_SETTING_URL
{
    return [NSString stringWithFormat:@"%@rest/services/application/appsettings?appkey=D7AwuC2qhqOmodKvQfUndIm6OK3A728c", BASE_URL];
}

+(NSString *)LOGIN_URL
{
    return [NSString stringWithFormat:@"%@rest/services/authentication/superusermanager",BASE_URL];
}

+(NSString *)FORGOT_PASSWORD_URL
{
    return [NSString stringWithFormat:@"%@rest/services/authentication/forgotpassword", BASE_URL];
}

+(NSString *)GET_PASSWORD_URL
{
    return [NSString stringWithFormat:@"%@rest/services/authentication/getpassword", BASE_URL];
}

+(NSString *) FOOTER_STATISTICS_URL
{
    return [NSString stringWithFormat:@"%@rest/services/dashboard/footerstatistics",BASE_URL];
}

#pragma mark - Dashboard

+(NSString *) TOTAL_ORDER_URL
{
    return [NSString stringWithFormat:@"%@rest/services/orders/totalorders", BASE_URL];
}

+(NSString *) TOTAL_ORDER_LIST_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/totalorderslist", BASE_URL];
}

+(NSString *) TOP_SELLERS_URL
{
    return [NSString stringWithFormat:@"%@rest/services/dashboard/topsellers", BASE_URL];
}

+(NSString *) FEEDBACK_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/dashboardfeedback", BASE_URL];
}

+(NSString *) FEEDBACK_TAG_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/feedbacktagstatistics", BASE_URL];
}

+(NSString *) FEEDBACK_BY_USER_URL
{
    return [NSString stringWithFormat:@"%@rest/services/user/userfeedback", BASE_URL];
}

+(NSString *) FEEDBACK_REPLY_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/feedbackemail", BASE_URL];
}

+(NSString *) OFFER_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/dashboardoffers", BASE_URL];
}

+(NSString *) OFFER_STATISTICS_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/dashboardofferstatistics", BASE_URL];
}

+(NSString *) GRAPH_URL
{
    return [NSString stringWithFormat:@"%@rest/Provider/getTrendChart", PROVIDER_BASE_URL];
}

#pragma mark - Restaurant Profile

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

+(NSString *) GET_TAX_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/additionalpayments", BASE_URL];
}

+(NSString *) UPDATE_TAX_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/updateadditionalpayments", BASE_URL];
}

#pragma mark - User

+(NSString *) GET_DELIVERY_PERSON_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/deliveryboys", BASE_URL];
}

+(NSString *) GET_MANAGER_URL
{
    return [NSString stringWithFormat:@"%@rest/services/manager/managers", BASE_URL];
}

+(NSString *) DELETE_MANAGER_URL
{
    return [NSString stringWithFormat:@"%@rest/services/manager/deletemanager", BASE_URL];
}

+(NSString *) DELETE_DELIVERY_PERSON_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/updatedeliveryboys", BASE_URL];
}

+(NSString *) INSERT_DELIVERY_PERSON_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/insertdeliveryboys", BASE_URL];
}

+(NSString *) INSERT_MANAGER_URL
{
    return [NSString stringWithFormat:@"%@rest/services/manager/insertmanager", BASE_URL];
}

#pragma mark - Offers

+(NSString *) GET_OFFERS_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/promocodes", BASE_URL];
}

+(NSString *) INSERT_OFFER_URL
{
    return [NSString stringWithFormat:@"%@rest/services/discounts/insertpromocode", BASE_URL];
}

+(NSString *) UPDATE_OFFER_URL
{
    return [NSString stringWithFormat:@"%@rest/services/discounts/updatepromocodes", BASE_URL];
}

#pragma mark - Menu

+(NSString *) GET_CATEGORIES_URL
{
    return [NSString stringWithFormat:@"%@rest/services/menu/category", BASE_URL];
}

+(NSString *) INSERT_CATEGORY_URL
{
    return [NSString stringWithFormat:@"%@rest/services/menu/insertcategory", BASE_URL];
}

+(NSString *) UPDATE_CATEGORY_URL
{
    return [NSString stringWithFormat:@"%@rest/services/menu/updatecategory", BASE_URL];
}

+(NSString *) GET_ITEMS_BY_CATEGORY_URL
{
    return [NSString stringWithFormat:@"%@rest/services/menu/provideritems", BASE_URL];
}

+(NSString *) INSERT_ITEM_URL
{
    return [NSString stringWithFormat:@"%@rest/services/menu/insertitem", BASE_URL];
}

+(NSString *) UPDATE_ITEM_URL
{
    return [NSString stringWithFormat:@"%@rest/services/menu/updateitem", BASE_URL];
}

#pragma mark - Landing Images

+(NSString *) GET_LANDING_PAGES_URL
{
    return [NSString stringWithFormat:@"%@rest/services/organization/images", BASE_URL];
}

+(NSString *) UPDATE_LANDING_IMAGE
{
    return [NSString stringWithFormat:@"%@rest/services/organization/updatelandingimage", BASE_URL];
}

#pragma mark - Orders

+(NSString *) GET_ALL_ORDERS_URL
{
    return [NSString stringWithFormat:@"%@rest/services/orders/getorders", BASE_URL];
}

+(NSString *) GET_ITEMS_BY_ORDER_URL
{
    return [NSString stringWithFormat:@"%@rest/services/dashboard/dashboardorderdetails", BASE_URL];
}

+(NSString *) UPDATE_ORDER_STATUS_URL
{
    return [NSString stringWithFormat:@"%@rest/services/orders/processorder", BASE_URL];
}

+(NSString *) UPDATE_ESTIMATED_TIME_URL
{
    return [NSString stringWithFormat:@"%@rest/services/orders/updateorder", BASE_URL];
}

+(NSString *) ASSIGN_DELIVERY_PERSON_URL
{
    return [NSString stringWithFormat:@"%@rest/services/orders/assigndelivery", BASE_URL];
}

+(NSString *) CANCEL_ORDER_URL
{
    return [NSString stringWithFormat:@"%@rest/services/orders/cancelorder", BASE_URL];
}

#pragma mark - Profile

+(NSString *) UPDATE_PROFILE
{
    return [NSString stringWithFormat:@"%@rest/services/manager/updatemanager", BASE_URL];
}

+(NSString *) CHANGE_PASSWORD
{
    return [NSString stringWithFormat:@"%@rest/services/organization/changemanagerpw", BASE_URL];
}

@end
