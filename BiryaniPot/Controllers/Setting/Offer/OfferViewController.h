//
//  OfferViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/22/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface OfferViewController : BaseViewController <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *addNewOfferButton;
@property (weak, nonatomic) IBOutlet UICollectionView *offerCollectionView;

@property (nonatomic, retain) NSMutableArray * offerArray;

@property (nonatomic, retain) NSOperationQueue *offerQueue ;

-(void)getOffers;
-(NSString *)changeDateFormat: (NSString *) currentDate;

@end
