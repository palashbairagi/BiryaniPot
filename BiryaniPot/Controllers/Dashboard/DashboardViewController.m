//
//  DashboardViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/22/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "DashboardViewController.h"
#import "TotalOrdersViewController.h"
#import "TopSellerViewController.h"
#import "OffersAvailedViewController.h"
#import "FeedbackViewController.h"
#import "Constants.h"
#import "Item.h"
#import "Offer.h"
#import "Graph.h"
#import "CalendarViewController.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_dateFrom setTitle:Constants.GET_FIFTEEN_DAYS_AGO_DATE forState:UIControlStateNormal];
    [_dateTo setTitle:Constants.GET_TODAY_DATE
             forState:UIControlStateNormal];
    [_dateFrom setTitle:Constants.GET_FIFTEEN_DAYS_AGO_DATE forState:UIControlStateSelected];
    [_dateTo setTitle:Constants.GET_TODAY_DATE forState:UIControlStateSelected];
    
    _happySmiley.text = [NSString stringWithFormat:@"%C", 0xf118];
    _sadSmiley.text = [NSString stringWithFormat:@"%C", 0xf119];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self initComponents];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:253.0/255.0 green:205.0/255.0 blue:25.0/255.0 alpha:1.0];
    [self.navigationItem setHidesBackButton:YES];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"Dashboard";
    backButton.tintColor = [UIColor colorWithRed:216.0/255.0 green:33.0/255.0 blue:42.0/255.0 alpha:1];
    
    self.navigationItem.backBarButtonItem = backButton;
}

-(void)initComponents
{
    self.graphArray = [[NSMutableArray alloc]init];
    
    self.durationSegmentedControl.frame = CGRectMake(0, 0, self.durationView.frame.size.width, self.durationView.frame.size.height);
    
    _durationView.layer.cornerRadius = CGRectGetHeight(_durationView.bounds) / 2;
    _durationView.layer.borderColor = [UIColor colorWithRed:206.0/255.0 green:96.0/255.0 blue:40.0/255.0 alpha:1].CGColor;
    _durationView.layer.borderWidth = 1;
    
    _topSellersArray = [[NSMutableArray alloc]init];
    _offersArray = [[NSMutableArray alloc]init];
    
    [self totalOrders];
    [self topSellers];
    [self feedback];
    [self offer];
    [self plotGraph];
}

- (void)createBarChart{
    BarChart *barChartView = [[BarChart alloc] initWithFrame:CGRectMake(20, 30, self.statisticsView.frame.size.width-40, self.statisticsView.frame.size.height-40)];
    [barChartView setDataSource:self];
    
    [barChartView setShowLegend:FALSE];
    [barChartView setLegendViewType:LegendTypeHorizontal];
    
    [barChartView setDrawGridY:TRUE];
    [barChartView setDrawGridX:TRUE];
    
    [barChartView setGridLineColor:[UIColor lightGrayColor]];
    [barChartView setGridLineWidth:0];
    
    [barChartView setTextFontSize:10];
    [barChartView setTextColor:[UIColor blackColor]];
    [barChartView setTextFont:[UIFont systemFontOfSize:barChartView.textFontSize]];
    [barChartView setTextFont:[UIFont fontWithName:@"Roboto" size:10]];
        
    [barChartView setShowCustomMarkerView:TRUE];

    [barChartView drawBarGraph];
    
    [self.statisticsView addSubview:barChartView];
 }

- (NSMutableArray *)xDataForBarChart{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _graphArray.count; i++)
    {
        Graph *graph = [_graphArray objectAtIndex:i];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        
        double timeStamp = [[NSString stringWithFormat:@"%@",graph.orderDate] doubleValue];
        NSTimeInterval timeInterval=timeStamp/1000;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        
        [dateFormat setDateFormat:@"dd"];
        NSString *myDayString = [dateFormat stringFromDate:date];
        
        [dateFormat setDateFormat:@"MMM"];
        NSString *myMonthString = [dateFormat stringFromDate:date];
        
        [array addObject:[NSString stringWithFormat:@"  %@ %@", myMonthString, myDayString]];
    }
    
    return array;
}

- (NSInteger)numberOfBarsToBePlotted{
    return 1;
}

- (UIColor *)colorForTheBarWithBarNumber:(NSInteger)barNumber{
    return [UIColor colorWithRed:216.0/256.0 green:216.0/256.0 blue:216.0/256.0 alpha:1];
}

- (CGFloat)widthForTheBarWithBarNumber:(NSInteger)barNumber{
    return 20;
}

- (NSString *)nameForTheBarWithBarNumber:(NSInteger)barNumber{
    return @"";//[NSString stringWithFormat:@"Data %d",(int)barNumber];
}

- (NSMutableArray *)yDataForBarWithBarNumber:(NSInteger)barNumber{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _graphArray.count; i++)
    {
        Graph *graph = [_graphArray objectAtIndex:i];
        [array addObject:[NSString stringWithFormat:@"%d", graph.totalOrders]];
    }
    
    return array;
}

- (UIView *)customViewForBarChartTouchWithValue:(NSNumber *)value{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view.layer setCornerRadius:4.0F];
    [view.layer setBorderWidth:1.0F];
    [view.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [view.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [view.layer setShadowRadius:2.0F];
    [view.layer setShadowOpacity:0.3F];
    
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:10]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:[NSString stringWithFormat:@"%@", value]];
    [label setFrame:CGRectMake(0, 0, 100, 30)];
    [view addSubview:label];
    
    [view setFrame:label.frame];
    return view;
}

-(void)totalOrders
{
    NSString *fromDate = @"2018-01-03";
    NSString *toDate = @"2018-01-26";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?loc_id=%@&from_date=%@&to_date=%@", Constants.TOTAL_ORDER_URL, Constants.LOCATION_ID, fromDate, toDate]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    NSArray *totalOrders = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    
    NSString *orders = [totalOrders[0] objectForKey:@"totalOrders"];
    NSString *amount = [totalOrders[0] objectForKey:@"totalPrice"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _totalOrdersLabel.text = [NSString stringWithFormat:@"%@ of $%@", orders, amount];
    });
}

-(void)topSellers
{
    NSString *fromDate = @"2018-01-03";
    NSString *toDate = @"2018-01-26";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?loc_id=%@&from_date=%@&to_date=%@", Constants.TOP_SELLERS_URL, Constants.LOCATION_ID, fromDate, toDate]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    NSArray *topSellers = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];

    for(NSDictionary *topSeller in topSellers)
    {
        NSString *itemName = [topSeller objectForKey:@"itemName"];
        NSString *total = [NSString stringWithFormat:@"%@", [topSeller objectForKey:@"timesSold"]];

        Item *item = [[Item alloc]init];
        item.name = itemName;
        item.quantity = total;
        
        [_topSellersArray addObject:item];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_topSellersTableView reloadData];
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

-(void)offer
{
    NSString *fromDate = @"2018-01-03";
    NSString *toDate = @"2018-01-26";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?loc_id=%@&from_date=%@&to_date=%@", Constants.OFFER_URL, Constants.LOCATION_ID, fromDate, toDate]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    NSArray *offers = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    
    for(NSDictionary *offer in offers)
    {
        NSString *codeName = [offer objectForKey:@"codeName"];
        NSString *timesApplied = [NSString stringWithFormat:@"%@", [offer objectForKey:@"timesApplied"]];
        
        Offer *of = [[Offer alloc]init];
        of.name = codeName;
        of.timesApplied = timesApplied;
        
        [_offersArray addObject:of];
    }
    
    [_offersTableView reloadData];
    [self offerStatistics];
}

-(void)offerStatistics
{
    NSString *fromDate = @"2018-01-03";
    NSString *toDate = @"2018-01-26";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?loc_id=%@&from_date=%@&to_date=%@&query=OFF20", Constants.OFFER_STATISTICS_URL, Constants.LOCATION_ID, fromDate, toDate]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    NSArray *offerStatistics = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    
    _activeOffersLabel.text = [NSString stringWithFormat:@"%@",[offerStatistics[0] objectForKey:@"activeOffers"]];
    _pointsRedeemedLabel.text = [NSString stringWithFormat:@"%@",[offerStatistics[0] objectForKey:@"points"]];
    _referralsLabel.text = [NSString stringWithFormat:@"%@",[offerStatistics[0] objectForKey:@"refferalCount"]];
}

-(void)plotGraph
{
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.GRAPH_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:@"POST"];
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc]init];
    [paramDict setValue:Constants.LOCATION_ID forKey:@"locId"];
    [paramDict setValue:@"2018-01-03" forKey:@"fromDate"];
    [paramDict setValue:@"2018-01-26" forKey:@"toDate"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:paramDict options:NSJSONWritingPrettyPrinted error:&error];
    
    [request setHTTPBody:data];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *trends = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        for(NSDictionary *trend in trends[@"trends"])
        {
            Graph *graph = [[Graph alloc]init];
            
            graph.orderDate = [trend valueForKey:@"date"];
            graph.totalOrders = [[trend valueForKey:@"total"] intValue];
            [self.graphArray addObject:graph];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
                [self createBarChart];
            });
    }];
    [postDataTask resume];
}

- (IBAction)totalOrdersTapped:(id)sender
{
    TotalOrdersViewController *tovc = [[TotalOrdersViewController alloc]init];
    [self.navigationController pushViewController:tovc animated:NO];
}


- (IBAction)topSellersTapped:(id)sender
{
    TopSellerViewController *tscv = [[TopSellerViewController alloc]init];
    [self.navigationController pushViewController:tscv animated:NO];
}

- (IBAction)feedbackTapped:(id)sender
{
    FeedbackViewController *fbvc = [[FeedbackViewController alloc]init];
    [self.navigationController pushViewController:fbvc animated:NO];
}

- (IBAction)offersTapped:(id)sender
{
    OffersAvailedViewController *favc = [[OffersAvailedViewController alloc]init];
    [self.navigationController pushViewController:favc animated:NO];
}

- (IBAction)orderTrendTapped:(id)sender
{
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.offersTableView)
    {
        if(_offersArray.count>=5)return 5;
        else return _offersArray.count;
    }
    else if (tableView == self.topSellersTableView)
    {
        if (_topSellersArray.count>=4)return 4;
        else return _topSellersArray.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.topSellersTableView)
    {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        Item *item = _topSellersArray[indexPath.row];
        cell.textLabel.text = item.name;
        cell.detailTextLabel.text = item.quantity;
        return cell;
    }
    else
    {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        Offer *offer = _offersArray[indexPath.row];
        cell.textLabel.text = offer.name;
        cell.detailTextLabel.text = offer.timesApplied;
        NSLog(@"Cell for row at index path %@",offer.name);
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.topSellersTableView)
    {
        return _topSellersTableView.frame.size.height/4;
    }
    else
    {
        return _offersTableView.frame.size.height/5;
    }
}

- (IBAction)editingBegin:(id)sender
{
    CalendarViewController * calendarVC = [[CalendarViewController alloc]init];
    calendarVC.modalPresentationStyle = UIModalPresentationFormSheet;
    calendarVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    calendarVC.preferredContentSize = CGSizeMake(500, 425);
    calendarVC.toDateDelegate = _dateTo;
    calendarVC.fromDateDelegate = _dateFrom;

    [self presentViewController:calendarVC animated:YES completion:nil];
}

@end
