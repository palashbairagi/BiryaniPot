//
//  OrderDetailTableViewCell.h
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 12/29/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "OrderDetailViewController.h"
#import "AddItemToOrderViewController.h"
#import "Validation.h"

@interface OrderDetailTableViewCell : UITableViewCell
@property (nonatomic, retain) OrderDetailViewController *delegate;
@property (nonatomic, retain) AddItemToOrderViewController *addItemDelegate;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *negativeButton;
@property (weak, nonatomic) IBOutlet UIButton *positiveButton;

@property (weak, nonatomic) IBOutlet UILabel *quantity;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UISegmentedControl *spiceLevel;
@property (weak, nonatomic) IBOutlet UIView *spiceView;
@property (weak, nonatomic) IBOutlet UIView *quantityView;

-(void)setCellData:(Item *)item isQueue:(BOOL) isQueue isPreparing:(BOOL) isPreparing;

@end
