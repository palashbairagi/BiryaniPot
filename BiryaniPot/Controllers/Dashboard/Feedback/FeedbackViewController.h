//
//  FeedbackViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/8/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PieChart.h"

@interface FeedbackViewController : BaseViewController <PieChartDataSource, UITableViewDelegate, UITableViewDataSource, NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UIView *positiveFeedbackView;
@property (weak, nonatomic) IBOutlet UIView *negativeFeedbackView;

@property (weak, nonatomic) IBOutlet UILabel *happySmiley;
@property (weak, nonatomic) IBOutlet UILabel *sadSmiley;
@property (weak, nonatomic) IBOutlet UILabel *happyValue;
@property (weak, nonatomic) IBOutlet UILabel *sadValue;
@property (weak, nonatomic) IBOutlet UITableView *feedbackTableView;

@property (nonatomic, retain) NSMutableArray *feedbackArray;
@property (nonatomic, retain) NSMutableDictionary *positiveDictionary, *negativeDictionary;

@property (nonatomic, retain) PieChart *positiveChart, *negativeChart;

@property (weak, nonatomic) IBOutlet UIButton *dateFrom;
@property (weak, nonatomic) IBOutlet UIButton *dateTo;

@property (nonatomic, retain) NSNumber *positiveQuantity, *positiveQuality, *positiveTaste, *positiveDelivery, *negativeQuantity, *negativeQuality, *negativeTaste, *negativeDelivery;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end
