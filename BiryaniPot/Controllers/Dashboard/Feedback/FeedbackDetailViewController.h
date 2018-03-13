//
//  FeedbackDetailViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 2/10/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *feedbackIcon;
@property (weak, nonatomic) IBOutlet UILabel *feedbackValue;
@property (weak, nonatomic) IBOutlet UITextView *feedbackDescription;
@property (weak, nonatomic) IBOutlet UILabel *dateAndTime;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UITextField *subject;
@property (weak, nonatomic) IBOutlet UILabel *customerName;
@property (weak, nonatomic) IBOutlet UITextView *message;

@end
