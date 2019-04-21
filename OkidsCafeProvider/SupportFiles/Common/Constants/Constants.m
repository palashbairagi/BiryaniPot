//
//  Constants.m
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 1/5/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "Constants.h"
#import "AppDelegate.h"
#import "Order.h"
#import "Item.h"

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
        DebugLog(@"%@ %@", e.name, e.reason);
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

+(NSString *) ACCESS_TOKEN
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return [appDelegate.userDefaults objectForKey:@"accessToken"];
}

+(NSString *) GET_LOCATION_DETAILS
{
    return [NSString stringWithFormat:@"%@rest/services/organization/getlocation", BASE_URL];
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
    return [NSString stringWithFormat:@"%@rest/services/application/appsettings?appkey=%@", BASE_URL, AppConfig.APP_KEY];
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
    //return [NSString stringWithFormat:@"http://www.mocky.io/v2/5b3db0d13100007d006de0f7"];
}

+(NSString *) OFFER_STATISTICS_URL
{
    return [NSString stringWithFormat:@"%@rest/services/dashboard/dashboardofferstatistics", BASE_URL];
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

+(NSString *) DELETE_CATEGORY_URL
{
    return [NSString stringWithFormat:@"%@rest/services/menu/deletecategory", BASE_URL];
}

+(NSString *) GET_ITEMS_BY_CATEGORY_URL
{
    return [NSString stringWithFormat:@"%@rest/services/menu/provideritems", BASE_URL];
}

+(NSString *) INSERT_ITEM_URL
{
    return [NSString stringWithFormat:@"%@rest/services/menu/additem", BASE_URL];
}

+(NSString *) UPDATE_ITEM_URL
{
    return [NSString stringWithFormat:@"%@rest/services/menu/updatemenuitem", BASE_URL];
}

+(NSString *) DELETE_ITEM_URL
{
    return [NSString stringWithFormat:@"%@rest/services/menu/deleteitem", BASE_URL];
}

+(NSString *) GET_RECOMMENDED_ITEMS_URL
{
    return [NSString stringWithFormat:@"%@rest/services/menu/addons", BASE_URL];
}

+(NSString *) ADD_RECOMMENDED_ITEMS_URL
{
    return [NSString stringWithFormat:@"%@rest/services/menu/updaterecommendeditem", BASE_URL];
}

+(NSString *) REMOVE_RECOMMENDED_ITEMS_URL
{
    return [NSString stringWithFormat:@"%@rest/services/menu/updaterecommendeditem", BASE_URL];
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

+(NSString *) FOOTER_STATISTICS_URL
{
    return [NSString stringWithFormat:@"%@rest/services/dashboard/footerstatistics",BASE_URL];
}

+(NSString *) GET_ALL_ORDERS_URL
{
    return [NSString stringWithFormat:@"%@rest/services/orders/getorders", BASE_URL];
}

+(NSString *) GET_ITEMS_BY_ORDER_URL
{
    return [NSString stringWithFormat:@"%@rest/services/dashboard/dashboardorderdetails", BASE_URL];
}

+(NSString *) UPDATE_ORDER_DETAIL
{
     return [NSString stringWithFormat:@"%@rest/services/orders/updateorderdetails", BASE_URL];
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
    return [NSString stringWithFormat:@"%@rest/services/manager/changepassword", BASE_URL];
}

#pragma mark - Print

+(void) printInvoice: (Print *) print
{
    Order *order = print.order;
    NSArray *itemArray = print.itemArray;
    
    if(order.customerName == NULL)order.customerName = @"";
    if(order.contactNumber == NULL)order.contactNumber = @"";
    
    NSMutableString *htmlString = [[NSMutableString alloc] init];
    
    [htmlString appendFormat:@"<table width='100%%'>"];
    [htmlString appendFormat:@"<tr><td colspan='3'><center><h1>Biryani Pot</h1></center></td></tr>"];
    [htmlString appendFormat:@"<td style='line-height:20px;' colspan=3>&nbsp;</td>"];
    [htmlString appendFormat:@"<tr><td colspan='2'><strong>%@</strong></td><td align='right'><strong>#%@</strong></td></tr>", order.customerName, order.orderNo];
    [htmlString appendFormat:@"<tr><td colspan='2'><strong>%@</strong></td><td align='right'><strong>%@</strong></td></tr>", order.contactNumber, order.orderTime];
    [htmlString appendFormat:@"<td style='line-height:20px;' colspan=3>&nbsp;</td>"];
    
    for (int i = 0; i < itemArray.count; i++)
    {
        Item *item = itemArray[i];
        [htmlString appendFormat:@"<tr><td width='65%%'>%@</td><td width='15%%' align = 'right'>%@</td><td width='20%%' align = 'right'>%.2f</td></tr>", item.name, item.quantity, ([item.price floatValue] * [item.quantity intValue])];
    }
    
    [htmlString appendFormat:@"<td style='line-height:10px;' colspan=3>&nbsp;</td>"];
    [htmlString appendFormat:@"<tr><td></td><td align = 'right'><b>Sub Total</b></td><td align='right'><b>%@%@</b></td></tr>", AppConfig.currencySymbol, order.subTotal];
    [htmlString appendFormat:@"<tr><td></td><td align = 'right'><b>Delivery Fee</b></td><td align='right'><b>%@%@</b></td></tr>", AppConfig.currencySymbol, order.deliveryFee];
    [htmlString appendFormat:@"<tr><td></td><td align = 'right'><b>Tip</b></td><td align='right'><b>%@%@</b></td></tr>", AppConfig.currencySymbol, order.tip];
    [htmlString appendFormat:@"<tr><td></td><td align = 'right'><b>Tax</b></td><td align='right'><b>%@%@</b></td></tr>", AppConfig.currencySymbol, order.tax];
    [htmlString appendFormat:@"<tr><td></td><td align = 'right'><b>Total</b></td><td align='right'><b>%@%@</b></td></tr>", AppConfig.currencySymbol, order.grandTotal];
    [htmlString appendFormat:@"<td style='line-height:40px;' colspan=3>&nbsp;</td>"];
    [htmlString appendFormat:@"<tr><td colspan = '3' align = 'center'><h3>%@</h3></td></tr>", order.deliveryType];
    [htmlString appendFormat:@"</table>"];
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    
    //pic.delegate = self;
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"PrintJob";
    pic.printInfo = printInfo;
    
    UIMarkupTextPrintFormatter *formatter = [[UIMarkupTextPrintFormatter alloc] initWithMarkupText:htmlString];
    formatter.contentInsets = UIEdgeInsetsMake(0,0,0,0); // 1" margins
    
    pic.printFormatter = formatter;
    [pic setShowsNumberOfCopies:false];
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        
        if (!completed && error) {
            
            DebugLog(@"Printing could not complete because of error: %@", error);
            
        }
        
    };
    
    [pic presentAnimated:YES completionHandler:completionHandler];
}

#pragma mark - Payment

+(NSString *) CARD_CONNECT_BASE_URL
{
    return @"https://fts.cardconnect.com:6443/";
}

+(NSString *) AUTHORIZATION_STRING
{
    return @"Basic dGVzdGluZzp0ZXN0aW5nMTIz";
}

+(NSString *) REFUND_URL
{
    return [NSString stringWithFormat:@"%@cardconnect/rest/void", Constants.CARD_CONNECT_BASE_URL];
}

+(NSString *) GET_PAYMENT_DETAIL_URL
{
    return [NSString stringWithFormat:@"%@rest/services/receipt/getPayments", BASE_URL];
}
@end
