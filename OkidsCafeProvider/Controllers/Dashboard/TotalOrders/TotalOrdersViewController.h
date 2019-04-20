//
//  TotalOrdersViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/9/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface TotalOrdersViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *totalOrdersTableView;
@property (weak, nonatomic) IBOutlet UILabel *totalOrdersLabel;

@property(nonatomic, retain) NSMutableArray *totalOrderArray;

@property (weak, nonatomic) IBOutlet UIButton *dateFrom;
@property (weak, nonatomic) IBOutlet UIButton *dateTo;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end
