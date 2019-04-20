//
//  AddItemToOrderViewController.h
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 1/21/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailViewController.h"

@interface AddItemToOrderViewController : UIViewController <NSURLSessionDelegate ,UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) OrderDetailViewController *delegate;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *customerName;
@property (weak, nonatomic) IBOutlet UILabel *contactNo;

@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;

@property (weak, nonatomic) IBOutlet UILabel *itemCount;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UILabel *revisedItemCount;
@property (weak, nonatomic) IBOutlet UILabel *revisedItemTotal;

@property (nonatomic, retain) NSMutableArray *categoryArray, *itemArray1;
@property (nonatomic, retain) NSMutableArray *invoiceItemArray;
@end
