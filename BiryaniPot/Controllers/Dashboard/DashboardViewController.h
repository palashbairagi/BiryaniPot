//
//  DashboardViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/22/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarChart.h"
#import "BaseViewController.h"

@interface DashboardViewController : BaseViewController <BarChartDataSource, UITableViewDelegate, UITableViewDataSource, NSURLSessionDelegate>
@property (weak, nonatomic) IBOutlet UIView *statisticsView;

@property (weak, nonatomic) IBOutlet UILabel *totalOrdersLabel;

@property (weak, nonatomic) IBOutlet UIView *topSellerView;

@property (weak, nonatomic) IBOutlet UIButton *dateFrom;
@property (weak, nonatomic) IBOutlet UIButton *dateTo;

@property (weak, nonatomic) IBOutlet UILabel *happySmiley;
@property (weak, nonatomic) IBOutlet UILabel *sadSmiley;
@property (weak, nonatomic) IBOutlet UILabel *happyValue;
@property (weak, nonatomic) IBOutlet UILabel *sadValue;

@property (weak, nonatomic) IBOutlet UITableView *topSellersTableView;
@property (weak, nonatomic) IBOutlet UITableView *offersTableView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *durationSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *durationView;

@property (nonatomic, retain) NSMutableArray *graphArray;
@property (nonatomic, retain) NSMutableArray *topSellersArray;
@property (nonatomic, retain) NSMutableArray *offersArray;

@end
