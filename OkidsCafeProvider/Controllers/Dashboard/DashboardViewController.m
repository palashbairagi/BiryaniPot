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
    [Constants SET_DASHBOARD_FROM_DATE:[_dateFrom currentTitle]];
    [Constants SET_DASHBOARD_TO_DATE:[_dateTo currentTitle]];
    
    _happySmiley.text = [NSString stringWithFormat:@"%C", 0xf118];
    _sadSmiley.text = [NSString stringWithFormat:@"%C", 0xf119];
}

-(void)viewDidAppear:(BOOL)animated
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
    _graphArray = [[NSMutableArray alloc]init];
    _topSellersArray = [[NSMutableArray alloc]init];
    _offersArray = [[NSMutableArray alloc]init];
    
    [self totalOrders];
    [self topSellers];
    [self feedback];
    [self offer];
    [self plotGraph];
}

-(void)totalOrders
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        NSString *fromDate = [Constants changeDateFormatForAPI:_dateFrom.currentTitle];
        NSString *toDate = [Constants changeDateFormatForAPI:_dateTo.currentTitle];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?loc_id=%@&from_date=%@&to_date=%@", Constants.TOTAL_ORDER_URL, Constants.LOCATION_ID, fromDate, toDate]];
        NSError *error = nil;
        NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
        
        DebugLog(@"Request %@", url);
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        NSDictionary *totalOrders = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Something went wrong"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        DebugLog(@"%@", totalOrders);
        
        long orders = [[totalOrders objectForKey:@"totalOrders"] longValue];
        double amount = [[totalOrders objectForKey:@"totalPrice"] doubleValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _totalOrdersLabel.text = [NSString stringWithFormat:@"%ld of %@%.2f", orders, AppConfig.currencySymbol, amount];
            [overlayView dismiss:YES];
        });
        
    }
    @catch(NSException *e)
    {
        DebugLog(@"DashboardViewController [totalOrders]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Something went wrong"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
}

-(void)topSellers
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        [_topSellersArray removeAllObjects];
    
        NSString *fromDate = [Constants changeDateFormatForAPI:_dateFrom.currentTitle];
        NSString *toDate = [Constants changeDateFormatForAPI:_dateTo.currentTitle];;
    
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?loc_id=%@&from_date=%@&to_date=%@", Constants.TOP_SELLERS_URL, Constants.LOCATION_ID, fromDate, toDate]];
        NSError *error = nil;
        NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
        
        DebugLog(@"Request %@", url);
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        NSDictionary *topSellersDic = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Something went wrong"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        DebugLog(@"%@", topSellersDic);
        
        NSArray *topSellersArray = [topSellersDic objectForKey:@"topSellers"];
    
        for(NSDictionary *topSeller in topSellersArray)
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
            [overlayView dismiss:YES];
        });
        
    }
    @catch(NSException *e)
    {
        DebugLog(@"DashboardViewController [topSellers]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Something went wrong"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
}

-(void)feedback
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        NSString *fromDate = [Constants changeDateFormatForAPI:_dateFrom.currentTitle];
        NSString *toDate = [Constants changeDateFormatForAPI:_dateTo.currentTitle];;
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?loc_id=%@&fromdate=%@&todate=%@", Constants.FEEDBACK_URL, Constants.LOCATION_ID, fromDate, toDate]];
        NSError *error = nil;
        NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
        
        DebugLog(@"Request %@", url);
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        NSArray *feedback = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Something went wrong"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        DebugLog(@"%@", feedback);
        
        _happyValue.text = [NSString stringWithFormat:@"%ld%%",[[feedback[0] objectForKey:@"goodCount"] longValue]];
        _sadValue.text = [NSString stringWithFormat:@"%ld%%",[[feedback[0] objectForKey:@"badCount"] longValue]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [overlayView dismiss:YES];
        });
        
    }
    @catch(NSException *e)
    {
        DebugLog(@"DashboardViewController [feedback]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Something went wrong"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
}

-(void)offer
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        [_offersArray removeAllObjects];
    
        NSString *fromDate = [Constants changeDateFormatForAPI:_dateFrom.currentTitle];
        NSString *toDate = [Constants changeDateFormatForAPI:_dateTo.currentTitle];;
    
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?loc_id=%@&from_date=%@&to_date=%@", Constants.OFFER_URL, Constants.LOCATION_ID, fromDate, toDate]];
        NSError *error = nil;
        
        DebugLog(@"Request %@", url);
        NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Something went wrong"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        DebugLog(@"%@", resultDic);
        
        _referralsLabel.text = [NSString stringWithFormat:@"%@", [resultDic objectForKey:@"referrals"]];
        _activeOffersLabel.text = [NSString stringWithFormat:@"%@", [resultDic objectForKey:@"active"]];
        _pointsRedeemedLabel.text = [NSString stringWithFormat:@"%@", [resultDic objectForKey:@"pointsRedeemed"] ];
        
        NSArray *offers = [resultDic objectForKey:@"offers"];
        
        for(NSDictionary *offer in offers)
        {
            NSString *codeName = [offer objectForKey:@"name"];
            NSString *timesApplied = [NSString stringWithFormat:@"%@", [offer objectForKey:@"applied"]];
            
            Offer *of = [[Offer alloc]init];
            of.name = codeName;
            of.timesApplied = timesApplied;
            
            [_offersArray addObject:of];
        }
    
        [_offersTableView reloadData];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [overlayView dismiss:YES];
        });
        
    }@catch(NSException *e)
    {
        DebugLog(@"DashboardViewController [offer]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Something went wrong"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
}

/*
-(void)offerStatistics
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        NSString *fromDate = [Constants changeDateFormatForAPI:_dateFrom.currentTitle];
        NSString *toDate = [Constants changeDateFormatForAPI:_dateTo.currentTitle];;
    
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?loc_id=%@&from_date=%@&to_date=%@", Constants.OFFER_STATISTICS_URL, Constants.LOCATION_ID, fromDate, toDate]];
        NSError *error = nil;
        NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
        
        DebugLog(@"Request %@", url);
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        NSArray *offerStatistics = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Something went wrong"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        DebugLog(@"%@", offerStatistics);
        
        _activeOffersLabel.text = [NSString stringWithFormat:@"%@",[offerStatistics[0] objectForKey:@"activeOffers"]];
        _pointsRedeemedLabel.text = [NSString stringWithFormat:@"%@",[offerStatistics[0] objectForKey:@"points"]];
        _referralsLabel.text = [NSString stringWithFormat:@"%@",[offerStatistics[0] objectForKey:@"refferalCount"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [overlayView dismiss:YES];
        });
        
    }@catch(NSException *e)
    {
        DebugLog(@"DashboardViewController [offerStatistics]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Something went wrong"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
}
*/

-(void)plotGraph
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        [_graphArray removeAllObjects];
        
        NSString *fromDate = [Constants changeDateFormatForAPI:_dateFrom.currentTitle];
        NSString *toDate = [Constants changeDateFormatForAPI:_dateTo.currentTitle];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.GRAPH_URL]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPMethod:@"POST"];
        NSMutableDictionary *paramDict = [[NSMutableDictionary alloc]init];
        [paramDict setValue:Constants.LOCATION_ID forKey:@"locId"];
        [paramDict setValue:fromDate forKey:@"fromDate"];
        [paramDict setValue:toDate forKey:@"toDate"];
        
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:paramDict options:NSJSONWritingPrettyPrinted error:&error];
        
        [request setHTTPBody:data];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            DebugLog(@"Request %@ Response %@", request, response);
            [overlayView setModeAndProgressWithStateOfTask:postDataTask];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            NSDictionary *trends = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Something went wrong"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            DebugLog(@"%@", trends);
            
            for(NSDictionary *trend in trends[@"trends"])
            {
                Graph *graph = [[Graph alloc]init];
                
                graph.orderDate = [trend valueForKey:@"date"];
                graph.totalOrders = [[trend valueForKey:@"total"] intValue];
                [self.graphArray addObject:graph];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self createBarChart];
                [overlayView dismiss:YES];
            });
        }];
        
        [postDataTask resume];
    }@catch(NSException *e)
    {
        DebugLog(@"DashboardViewController [plotGraph]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Something went wrong"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
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
    calendarVC.preferredContentSize = CGSizeMake(400, 450);
    calendarVC.toDateDelegate = _dateTo;
    calendarVC.fromDateDelegate = _dateFrom;
    calendarVC.disableFutureDates = true;
    calendarVC.didDismiss = ^(void){
        [self datesUpdated];
    };
    
    [self presentViewController:calendarVC animated:YES completion:nil];
}

-(void)datesUpdated
{
    [Constants SET_DASHBOARD_FROM_DATE:[_dateFrom currentTitle]];
    [Constants SET_DASHBOARD_TO_DATE:[_dateTo currentTitle]];
    
    @try
    {
        [self totalOrders];
    }@catch(NSException *e)
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Unable to get total orders"];
        DebugLog(@"%@ %@", e.name, e.reason);
    }
    
    @try
    {
        [self topSellers];
    }@catch(NSException *e)
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Unable to get top sellers"];
        DebugLog(@"%@ %@", e.name, e.reason);
    }
    
    @try
    {
        [self feedback];
    }@catch(NSException *e)
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Unable to get feedback"];
        DebugLog(@"%@ %@", e.name, e.reason);
    }
    
    @try
    {
        [self offer];
    }@catch(NSException *e)
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Unable to get offers"];
        DebugLog(@"%@ %@", e.name, e.reason);
    }
    
    @try
    {
        [_statisticsView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [_statisticsView addSubview: _orderTrendLabel];
        [self plotGraph];
    }@catch(NSException *e)
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Unable to get order trend"];
        DebugLog(@"%@ %@", e.name, e.reason);
    }
    
}

@end
