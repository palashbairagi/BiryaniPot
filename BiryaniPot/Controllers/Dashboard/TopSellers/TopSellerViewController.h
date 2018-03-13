//
//  TopSellerViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/8/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <SCRSidewaysBarGraph/SCRSidewaysBarGraph.h>

@interface TopSellerViewController : BaseViewController <NSURLSessionDelegate>
@property (nonatomic, retain) SCRSidewaysBarGraph *graph;
@property (nonatomic, retain) NSMutableArray *yAxisArray;
@property (nonatomic, retain) NSMutableArray *xAxisArray;
@property (weak, nonatomic) IBOutlet UIView *topSellersView;
@property (weak, nonatomic) IBOutlet UIButton *dateFrom;
@property (weak, nonatomic) IBOutlet UIButton *dateTo;

@end
