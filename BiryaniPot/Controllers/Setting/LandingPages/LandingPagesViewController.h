//
//  LandingPagesViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/10/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LandingPagesViewController : BaseViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *landingPageCollectionView;

@property (nonatomic, retain) NSMutableArray *landingImageArray;

@property (nonatomic, retain) NSOperationQueue *imageQueue ;

@end
