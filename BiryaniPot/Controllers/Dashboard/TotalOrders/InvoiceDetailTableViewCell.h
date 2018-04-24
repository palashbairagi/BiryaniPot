//
//  InvoiceDetailTableViewCell.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 3/20/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoiceDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *quantity;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
