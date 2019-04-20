//
//  TaxViewController.h
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 5/19/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Validation.h"

@interface TaxViewController : UIViewController <NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UITextField *taxNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *taxTextField;
@property (weak, nonatomic) IBOutlet UITextField *deliveryTextField;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end
