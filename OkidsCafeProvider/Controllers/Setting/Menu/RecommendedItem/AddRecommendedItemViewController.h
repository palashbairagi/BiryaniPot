//
//  AddRecommendedItemViewController.h
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 5/22/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface AddRecommendedItemViewController : UIViewController <NSURLSessionDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) MenuViewController *delegate;

@property (nonatomic, retain) Item *selectedItem;

@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;

@property (nonatomic, retain) NSMutableArray *categoryArray;
@property (nonatomic, retain) NSMutableArray *itemArray;
@property (nonatomic, retain) NSMutableArray *recommendedItemArray;

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end
