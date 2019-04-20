//
//  UserTableViewCell.h
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 12/27/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "UserManagementViewController.h"

@interface UserTableViewCell : UITableViewCell <NSURLSessionDelegate>
@property (nonatomic, retain)  UserManagementViewController *delegate;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *role;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
@property (weak, nonatomic) IBOutlet UILabel *licenceNo;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic, retain) NSOperationQueue *profilePictureQueue ;

- (void)setCellData:(User *)user withSelectedIndex:(NSInteger)selectedIndex;
@end
