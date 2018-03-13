//
//  FeedbackTableViewCell.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/9/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feedback.h"

@interface FeedbackTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *contactNumber;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *isPaid;
@property (weak, nonatomic) IBOutlet UILabel *smiley;

- (void)setCellData:(Feedback *)feedback;
@end
