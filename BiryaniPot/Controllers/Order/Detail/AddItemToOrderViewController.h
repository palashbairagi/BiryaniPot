//
//  AddItemToOrderViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/21/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddItemToOrderViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *customerName;
@property (weak, nonatomic) IBOutlet UILabel *contactNo;

@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, retain) NSMutableArray *categoryArray, *itemArray;
@end
