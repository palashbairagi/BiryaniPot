//
//  TotalOrdersViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/9/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "TotalOrdersViewController.h"
#import "TotalOrdersTableViewCell.h"
#import "Constants.h"
#import "Feedback.h"

@interface TotalOrdersViewController ()

@end

@implementation TotalOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.totalOrdersTableView registerNib:[UINib nibWithNibName:@"TotalOrdersTableViewCell" bundle:nil] forCellReuseIdentifier:@"totalOrdersCell"];
    _totalOrderArray = [[NSMutableArray alloc]init];
    
    [_dateFrom setTitle:Constants.GET_FIFTEEN_DAYS_AGO_DATE forState:UIControlStateNormal];
    [_dateTo setTitle:Constants.GET_TODAY_DATE
             forState:UIControlStateNormal];
    [_dateFrom setTitle:Constants.GET_FIFTEEN_DAYS_AGO_DATE forState:UIControlStateSelected];
    [_dateTo setTitle:Constants.GET_TODAY_DATE forState:UIControlStateSelected];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self totalOrdersList];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _totalOrderArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TotalOrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"totalOrdersCell"];
    Feedback *totalOrders = _totalOrderArray[indexPath.row];
    cell.delegate = self;
    [cell setCellData:totalOrders];
    return cell;
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

        [_totalOrderArray addObject:feedback];
    }
        
    dispatch_async(dispatch_get_main_queue(), ^{
        [_totalOrdersTableView reloadData];
    });
    
    [self totalOrders];
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

@end
