//
//  LocationViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/22/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TaxViewController.h"

@interface ProfileViewController : BaseViewController <NSURLSessionDelegate>
@property (weak, nonatomic) IBOutlet UIView *saveAndCancelView;
@property (weak, nonatomic) IBOutlet UIView *openingHoursView;
@property (weak, nonatomic) IBOutlet UIView *openingHoursHeaderView;


@property (weak, nonatomic) IBOutlet UIButton *taxButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UITextField *addressLine1;
@property (weak, nonatomic) IBOutlet UITextField *phone1;
@property (weak, nonatomic) IBOutlet UITextField *phone2;
@property (weak, nonatomic) IBOutlet UITextField *addressLine2;
@property (weak, nonatomic) IBOutlet UITextField *zip;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *state;

@property (weak, nonatomic) IBOutlet UIButton *sun_from;
@property (weak, nonatomic) IBOutlet UIButton *sun_to;
@property (weak, nonatomic) IBOutlet UIButton *mon_from;
@property (weak, nonatomic) IBOutlet UIButton *mon_to;
@property (weak, nonatomic) IBOutlet UIButton *tue_from;
@property (weak, nonatomic) IBOutlet UIButton *tue_to;
@property (weak, nonatomic) IBOutlet UIButton *wed_from;
@property (weak, nonatomic) IBOutlet UIButton *wed_to;
@property (weak, nonatomic) IBOutlet UIButton *thu_from;
@property (weak, nonatomic) IBOutlet UIButton *thu_to;
@property (weak, nonatomic) IBOutlet UIButton *fri_from;
@property (weak, nonatomic) IBOutlet UIButton *fri_to;
@property (weak, nonatomic) IBOutlet UIButton *sat_from;
@property (weak, nonatomic) IBOutlet UIButton *sat_to;

@property (weak, nonatomic) IBOutlet UILabel *monday;
@property (weak, nonatomic) IBOutlet UILabel *sunday;
@property (weak, nonatomic) IBOutlet UILabel *tuesday;
@property (weak, nonatomic) IBOutlet UILabel *wednesday;
@property (weak, nonatomic) IBOutlet UILabel *thursday;
@property (weak, nonatomic) IBOutlet UILabel *friday;
@property (weak, nonatomic) IBOutlet UILabel *saturday;

@end
