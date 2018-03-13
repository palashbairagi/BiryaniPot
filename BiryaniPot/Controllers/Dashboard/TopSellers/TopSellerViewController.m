//
//  TopSellerViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/8/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "TopSellerViewController.h"
#import "Constants.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

@interface TopSellerViewController ()

@end

@implementation TopSellerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_dateFrom setTitle:Constants.GET_FIFTEEN_DAYS_AGO_DATE forState:UIControlStateNormal];
    [_dateTo setTitle:Constants.GET_TODAY_DATE
             forState:UIControlStateNormal];
    [_dateFrom setTitle:Constants.GET_FIFTEEN_DAYS_AGO_DATE forState:UIControlStateSelected];
    [_dateTo setTitle:Constants.GET_TODAY_DATE forState:UIControlStateSelected];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    _xAxisArray =  [[NSMutableArray alloc]init];
    _yAxisArray = [[NSMutableArray alloc]init];
    
    [self topSellers];
    
    //_graph = [[SCRSidewaysBarGraph alloc] initWithFrame:CGRectMake(60, 60, CGRectGetWidth(self.topSellersView.frame) - 120, [SCRSidewaysBarGraph expectedHeightWithBars:5]) yAxisLabels:_yAxisArray xValues:_xAxisArray maxXValue:50 showCount:NO];
    
    _graph = [[SCRSidewaysBarGraph alloc] initWithFrame:CGRectMake(60, 60, CGRectGetWidth(self.topSellersView.frame) - 120, CGRectGetHeight(self.topSellersView.frame)-200)];
    
    _graph.barFillColor = RGB(206, 96, 40);
    _graph.barBackgroundColor = RGB(255,255,255);
    _graph.labelTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0f]};
    _graph.countTextAttributes = _graph.labelTextAttributes;
    //_graph.showCount = YES;
    [self.topSellersView addSubview:_graph];
}

-(void)topSellers
{
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.TOP_SELLERS_URL]];
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
        NSDictionary *topSellers = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        for(NSDictionary *topSeller in topSellers[@"sellers"])
        {
            NSString *itemName = [topSeller objectForKey:@"itemName"];
            NSString *total = [topSeller objectForKey:@"total"];
            
            [_yAxisArray addObject:itemName];
            [_xAxisArray addObject:total];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_graph setXValues:_xAxisArray];
            [_graph setYAxisLabels:_yAxisArray];
            [_graph setMaxXValue:10];
            [_graph reloadInputViews];
        });
        
    }];
    [postDataTask resume];
}

@end
