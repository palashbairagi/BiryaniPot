//
//  LoginViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/22/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LoginViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic, retain) NSUserDefaults *userDefaults;
@end
