//
//  OffersAvailedViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/8/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MultiLineGraphView.h"

@interface OffersAvailedViewController : BaseViewController <MultiLineGraphViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *offersAvailedView;
@property (weak, nonatomic) IBOutlet UIButton *dateFrom;
@property (weak, nonatomic) IBOutlet UIButton *dateTo;

@property (nonatomic, retain) NSMutableArray *offersArray;

@end
