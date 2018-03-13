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
}

-(void)viewDidAppear:(BOOL)animated
{
    [self initComponents];
    [self createPieChart];
    [self feedback];
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
    
    [_positiveChart drawPieChart];
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
    
    [_negativeChart drawPieChart];
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

- (NSNumber *)valueInPieChartWithIndex:(NSInteger)index{
    return [NSNumber numberWithLong:random() % 100];
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
    [label setText:[NSString stringWithFormat:@"Pie Data: %@", value]];
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
    NSLog(@"DId select row");
    FeedbackDetailViewController *feedbackDetailVC = [[FeedbackDetailViewController alloc]init];
    feedbackDetailVC.modalPresentationStyle = UIModalPresentationFormSheet;
    feedbackDetailVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    feedbackDetailVC.preferredContentSize = CGSizeMake(800, 500);
    
    [self presentViewController:feedbackDetailVC animated:YES completion:nil];
}

-(void)feedback
{
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.FEEDBACK_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:@"POST"];
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc]init];
    [paramDict setValue:@"1" forKey:@"locId"];
    [paramDict setValue:@"2018-1-03" forKey:@"fromDate"];
    [paramDict setValue:@"2018-1-26" forKey:@"toDate"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:paramDict options:NSJSONWritingPrettyPrinted error:&error];
    
    [request setHTTPBody:data];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *feedbacks = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        for(NSDictionary *feedback in feedbacks[@"orders"])
        {
            NSString *smiley = [feedback objectForKey:@"feedback"];
            NSString *orderId = [feedback objectForKey:@"orderId"];
            NSString *orderType = [feedback objectForKey:@"orderType"];
            NSString *paymentType = [feedback objectForKey:@"paymentType"];
            NSString *totalAmount = [feedback objectForKey:@"totalAmount"];
            NSString *userEmail = [feedback objectForKey:@"userEmail"];
            NSString *userMobile = [feedback objectForKey:@"userMobile"];
            
            Feedback *feedback1 = [[Feedback alloc]init];
            feedback1.smiley = smiley;
            feedback1.orderNo = orderId;
            feedback1.orderType = orderType;
            feedback1.paymentType = paymentType;
            feedback1.amount = totalAmount;
            feedback1.email = userEmail;
            feedback1.contactNumber = userMobile;
            
            [_feedbackArray addObject:feedback1];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_feedbackTableView reloadData];
        });
        
        NSString *positive = [feedbacks objectForKey:@"positivePercent"];
        NSString *negative = [feedbacks objectForKey:@"negitivePercent"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _happyValue.text = [NSString stringWithFormat:@"%@%%", positive];
            _sadValue.text = [NSString stringWithFormat:@"%@%%", negative];
        });
        
        for(NSDictionary *feedback in feedbacks[@"positive"])
        {
            
        }
        
    }];
    [postDataTask resume];
}

@end
