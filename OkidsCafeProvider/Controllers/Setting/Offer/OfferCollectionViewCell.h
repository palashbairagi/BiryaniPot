//
//  OfferCollectionViewCell.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/21/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfferViewController.h"
#import "Offer.h"

@interface OfferCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) OfferViewController * delegate;
@property (weak, nonatomic) IBOutlet UILabel *promoCode;
@property (weak, nonatomic) IBOutlet UIImageView *offerImage;
@property (weak, nonatomic) IBOutlet UILabel *offerDescription;
@property (weak, nonatomic) IBOutlet UILabel *startsFrom;
@property (weak, nonatomic) IBOutlet UILabel *expiresOn;
@property (weak, nonatomic) IBOutlet UIView *disableView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
