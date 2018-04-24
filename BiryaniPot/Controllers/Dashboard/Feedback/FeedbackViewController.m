//
//  FeedbackViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/8/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedbackTableViewCell.h"
#import "Feedback.h"
#import "Constants.h"
#import "FeedbackDetailViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _positiveTaste = 0;
//    _positiveQuality = 0;
//    _positiveQuantity = 0;
//    _positiveDelivery = 0;
//
//    _negativeTaste = 0;
//    _negativeQuality = 0;
//    _negativeQuantity = 0;
//    _negativeDelivery = 0;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self feedbackTags];
    [self initComponents];
    [self feedback];
    [self totalOrdersList];
}

-(void)initComponents
{
    _happySmiley.text = [NSString stringWithFormat:@"%C", 0xf118];
    _sadSmiley.text = [NSString stringWithFormat:@"%C", 0xf119];
    
    [self.feedbackTableView registerNib:[UINib nibWithNibName:@"FeedbackTableViewCell" bundle:nil] forCellReuseIdentifier:@"feedbackCell"];
    _feedbackArray = [[NSMutableArray alloc]init];
    
    _positiveDictionary = [[NSMutableDictionary alloc]init];
    _negativeDictionary = [[NSMutableDictionary alloc]init];
    
    [_dateFrom setTitle:Constants.GET_FIFTEEN_DAYS_AGO_DATE forState:UIControlStateNormal];
    [_dateTo setTitle:Constants.GET_TODAY_DATE
             forState:UIControlStateNormal];
    [_dateFrom setTitle:Constants.GET_FIFTEEN_DAYS_AGO_DATE forState:UIControlStateSelected];
    [_dateTo setTitle:Constants.GET_TODAY_DATE forState:UIControlStateSelected];
}

- (void)createPieChart{
    _positiveChart = [[PieChart alloc] initWithFrame:CGRectMake(100, 10, self.positiveFeedbackView.bounds.size.width-80, self.positiveFeedbackView.bounds.size.height-20)];
    [_positiveChart setDataSource:self];
    
    [_positiveChart setShowLegend:TRUE];
    [_positiveChart setLegendViewType:LegendTypeHorizontal];
    
    [_positiveChart setTextFontSize:12];
    [_positiveChart setTextColor:[UIColor blackColor]];
    [_positiveChart setTextFont:[UIFont systemFontOfSize:_positiveChart.textFontSize]];
    
    [_positiveChart setShowValueOnPieSlice:TRUE];
    [_positiveChart setShowCustomMarkerView:TRUE];
    
    [_positiveChart drawPieChart:_positiveChart];
    [self.positiveFeedbackView addSubview:_positiveChart];
    
    _negativeChart = [[PieChart alloc] initWithFrame:CGRectMake(100, 10, self.negativeFeedbackView.bounds.size.width-80, self.negativeFeedbackView.bounds.size.height-20)];
    [_negativeChart setDataSource:self];
    
    [_negativeChart setShowLegend:TRUE];
    [_negativeChart setLegendViewType:LegendTypeHorizontal];
    
    [_negativeChart setTextFontSize:12];
    [_negativeChart setTextColor:[UIColor blackColor]];
    [_negativeChart setTextFont:[UIFont systemFontOfSize:_negativeChart.textFontSize]];
    
    [_negativeChart setShowValueOnPieSlice:TRUE];
    [_negativeChart setShowCustomMarkerView:TRUE];
    
    [_negativeChart drawPieChart:_negativeChart];
    [self.negativeFeedbackView addSubview:_negativeChart];
}

- (NSInteger)numberOfValuesForPieChart{
    return 4;
}

- (UIColor *)colorForValueInPieChartWithIndex:(NSInteger)lineNumber{
    switch (lineNumber) {
        case 0:
            return [UIColor colorWithRed:237.0/256.0 green:120/256.0 blue:11.0/256.0 alpha:1];
            break;
            
        case 1:
            return [UIColor colorWithRed:74.0/256.0 green:144/256.0 blue:226.0/256.0 alpha:1];
            break;
            
        case 2:
            return [UIColor colorWithRed:80.0/256.0 green:227/256.0 blue:194.0/256.0 alpha:1];
            break;
            
        case 3:
            return [UIColor colorWithRed:180.0/256.0 green:180.0/256.0 blue:180.0/256.0 alpha:180.0/256.0];
            break;
            
    }
    return [UIColor whiteColor];
}

- (NSString *)titleForValueInPieChartWithIndex:(NSInteger)index{
    
    switch (index) {
        case 0:
            return [NSString stringWithFormat:@"Ontime Delivery"];
            break;
            
        case 1:
            return [NSString stringWithFormat:@"Taste"];
            break;
        
        case 2:
            return [NSString stringWithFormat:@"Food Quantity"];
            break;
        
        case 3:
            return [NSString stringWithFormat:@"Food Quality"];
            break;
        
    }
    return [NSString stringWithFormat:@""];
}

- (NSNumber *)valueInPieChartWithIndex:(NSInteger)index inPieChart:(PieChart *) pieChart{
    
    if (pieChart == _positiveChart)
    {
        switch (index) {
            case 0:
                return _positiveDelivery;
                break;
                
            case 1:
                return _positiveTaste;
                break;
                
            case 2:
                return _positiveQuantity;
                break;
                
            case 3:
                return _positiveQuality;
                break;
        }
    }
    else
    {
        switch (index) {
            case 0:
                return _negativeDelivery;
                break;
                
            case 1:
                return _negativeTaste;
                break;
                
            case 2:
                return _negativeQuantity;
                break;
                
            case 3:
                return _negativeQuality;
                break;
        }
    }
    return [NSNumber numberWithLong:0];
}

- (UIView *)customViewForPieChartTouchWithValue:(NSNumber *)value{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view.layer setCornerRadius:4.0F];
    [view.layer setBorderWidth:1.0F];
    [view.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [view.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [view.layer setShadowRadius:2.0F];
    [view.layer setShadowOpacity:0.3F];
    
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:[NSString stringWithFormat:@"%@", value]];
    [label setFrame:CGRectMake(0, 0, 100, 30)];
    [view addSubview:label];
    
    [view setFrame:label.frame];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _feedbackArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedbackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedbackCell"];
    Feedback *feedback = _feedbackArray[indexPath.row];
    [cell setCellData:feedback];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Feedback *feedback = _feedbackArray[indexPath.row];
    
    if (feedback.smiley == nil || [feedback.smiley isEqualToString:@""])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"No Ratings"];
        return;
    }
    
    FeedbackDetailViewController *feedbackDetailVC = [[FeedbackDetailViewController alloc]init];
    feedbackDetailVC.modalPresentationStyle = UIModalPresentationFormSheet;
    feedbackDetailVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    feedbackDetailVC.preferredContentSize = CGSizeMake(800, 500);
    feedbackDetailVC.delegate = _feedbackArray[indexPath.row];
    
    [self presentViewController:feedbackDetailVC animated:YES completion:nil];
}

-(void)totalOrdersList
{
    NSString *fromDate = @"2018-01-03";
    NSString *toDate = @"2018-01-26";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?loc_id=%@&fromdate=%@&todate=%@", Constants.TOTAL_ORDER_LIST_URL, Constants.LOCATION_ID, fromDate, toDate]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    NSArray *totalOrders = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    
    for(NSDictionary *totalOrder in totalOrders)
    {
        NSString *smiley = [totalOrder objectForKey:@"feedbackType"];
        NSString *orderId = [NSString stringWithFormat:@"%@", [totalOrder objectForKey:@"orderId"]];
        NSString *orderType = [totalOrder objectForKey:@"orderType"];
        NSString *paymentType = [totalOrder objectForKey:@"paymentType"];
        NSString *totalAmount = [NSString stringWithFormat:@"%@",[totalOrder objectForKey:@"totalOrdersAmount"]];
        NSString *userEmail = [totalOrder objectForKey:@"userEmail"];
        NSString *userMobile = [totalOrder objectForKey:@"userPhone"];
        
        Feedback *feedback = [[Feedback alloc]init];
        feedback.smiley = smiley;
        feedback.orderNo = orderId;
        feedback.orderType = orderType;
        feedback.paymentType = paymentType;
        feedback.amount = totalAmount;
        feedback.email = userEmail;
        feedback.contactNumber = userMobile;
        
        [_feedbackArray addObject:feedback];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_feedbackTableView reloadData];
    });
}

-(void)feedbackTags
{
    NSString *fromDate = @"2018-01-03";
    NSString *toDate = @"2018-01-26";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?loc_id=%@&fromdate=%@&todate=%@", Constants.FEEDBACK_TAG_URL, Constants.LOCATION_ID, fromDate, toDate]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    NSArray *feedbackTags = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    
    for(NSDictionary *feedbackTag in feedbackTags)
    {
        NSString *tagName = [feedbackTag objectForKey:@"tagName"];
        NSString *tagType = [feedbackTag objectForKey:@"tagType"];
        NSNumber *tagCount = [NSNumber numberWithFloat:[[feedbackTag objectForKey:@"tagCount"] floatValue]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([tagType isEqualToString:@"Good"])
            {
                if ([tagName isEqualToString:@"Food Quality"])
                {
                    _positiveQuality = tagCount;
                }
                else if ([tagName isEqualToString:@"Food Quantity"])
                {
                    _positiveQuantity = tagCount;
                }
                else if ([tagName isEqualToString:@"Taste"])
                {
                    _positiveTaste = tagCount;
                }
                else
                {
                    _positiveDelivery = tagCount;
                }
            }
            else
            {
                if ([tagName isEqualToString:@"Food Quality"])
                {
                    _negativeQuality = tagCount;
                }
                else if ([tagName isEqualToString:@"Food Quantity"])
                {
                    _negativeQuantity = tagCount;
                }
                else if ([tagName isEqualToString:@"Taste"])
                {
                    _negativeTaste = tagCount;
                }
                else
                {
                    _negativeDelivery = tagCount;
                }
            }
            
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createPieChart];
    });
}

-(void)feedback
{
    NSString *fromDate = @"2018-01-03";
    NSString *toDate = @"2018-01-26";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?loc_id=%@&fromdate=%@&todate=%@", Constants.FEEDBACK_URL, Constants.LOCATION_ID, fromDate, toDate]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    NSArray *feedback = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    
    _happyValue.text = [NSString stringWithFormat:@"%@%%",[feedback[0] objectForKey:@"goodCount"]];
    _sadValue.text = [NSString stringWithFormat:@"%@%%",[feedback[0] objectForKey:@"badCount"]];
}
@end
