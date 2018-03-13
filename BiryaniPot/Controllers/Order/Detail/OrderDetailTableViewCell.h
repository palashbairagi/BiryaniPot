//
//  OrderDetailTableViewCell.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/29/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface OrderDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *negativeButton;
@property (weak, nonatomic) IBOutlet UIButton *positiveButton;
@property (weak, nonatomic) IBOutlet UILabel *quantity;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UISegmentedControl *spiceLevel;

-(void)setCellData:(Item *)item;

@end
