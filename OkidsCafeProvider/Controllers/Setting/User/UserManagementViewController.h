//
//  EmployeeViewController.h
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 12/22/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AppDelegate.h"

@interface UserManagementViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *addNewMemberButton;
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@property (nonatomic, retain) NSMutableArray * userArray;
@property (nonatomic, retain) AppDelegate *appDelegate;

@property int managerCount, partnerCount;

-(void)getDeliveryPersons;
-(void)getManagers;
@end
