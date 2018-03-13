//
//  CancelViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/29/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface CancelViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *customerName;
@property (nonatomic, retain) Order *order;
@property (nonatomic, retain) id delegate;
@end
