//
//  OrderViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/22/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface OrderViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *waitView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UITextField *search;

@property (weak, nonatomic) IBOutlet UILabel *totalOrders;
@property (weak, nonatomic) IBOutlet UILabel *delivered;
@property (weak, nonatomic) IBOutlet UILabel *pickedUp;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, retain) UIScrollView *containerScrollView;

@property (nonatomic, retain) UILabel *queueLabel, *preparingLabel, *outForDeliveryLabel, *readyToPickUpLabel, *completeLabel;

@property (nonatomic, retain) UITableView *searchTableView;
@property (nonatomic, retain) UITableView *queueTableView;
@property (nonatomic, retain) UITableView *preparingTableView;
@property (nonatomic, retain) UITableView *outForDeliveryTableView;
@property (nonatomic, retain) UITableView *readyToPickupTableView;
@property (nonatomic, retain) UITableView *completeTableView;

@property (nonatomic, retain) NSMutableArray * searchArray;
@property (nonatomic, retain) NSMutableArray * queueArray;
@property (nonatomic, retain) NSMutableArray * preparingArray;
@property (nonatomic, retain) NSMutableArray * outForDeliveryArray;
@property (nonatomic, retain) NSMutableArray * readyToPickUpArray;
@property (nonatomic, retain) NSMutableArray * completeArray;

-(void)getAllOrders;
-(void)loadData;

- (IBAction)searchTextChanged:(id)sender;
@end
