//
//  MenuViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/10/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "BaseViewController.h"

@interface MenuViewController : BaseViewController <UICollectionViewDelegate, UICollectionViewDataSource, NSURLSessionDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *recommendedItemCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *deleteItemButton;
@property (weak, nonatomic) IBOutlet UIButton *addCategoryButton;

@property (nonatomic, retain) NSMutableArray *categoryArray;
@property (nonatomic, retain) NSMutableArray *itemArray;
@property (nonatomic, retain) NSMutableArray *recommendedItemArray;

@property (nonatomic, retain) NSOperationQueue *categoryQueue ;

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *discount;
@property (weak, nonatomic) IBOutlet UITextView *detail;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
