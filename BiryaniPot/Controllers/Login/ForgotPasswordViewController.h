//
//  ForgotPasswordViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/7/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Validation.h"

@interface ForgotPasswordViewController : UIViewController <NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIButton *sendMePassword;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UILabel *otpLabel;
@property (nonatomic, retain) NSString  *sessionId;

@end
