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
    [self totalOrders];
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

-(void)totalOrders
{
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.TOTAL_ORDER_URL]];
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
        NSDictionary *totalOrders = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        for(NSDictionary *totalOrder in totalOrders[@"orders"])
        {
           // NSString *smiley = [totalOrder objectForKey:@"feedback"];
            NSString *orderId = [totalOrder objectForKey:@"orderId"];
            NSString *orderType = [totalOrder objectForKey:@"orderType"];
            NSString *paymentType = [totalOrder objectForKey:@"paymentType"];
            NSString *totalAmount = [totalOrder objectForKey:@"totalAmount"];
            NSString *userEmail = [totalOrder objectForKey:@"userEmail"];
            NSString *userMobile = [totalOrder objectForKey:@"userMobile"];
            
            Feedback *feedback = [[Feedback alloc]init];
          //  feedback.smiley = smiley;
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
    }];
    [postDataTask resume];
}

@end
