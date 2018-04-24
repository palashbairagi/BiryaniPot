//
//  EmployeeViewController.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/22/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface UserManagementViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *addNewMemberButton;
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@property (nonatomic, retain) NSMutableArray * userArray;

-(void)getDeliveryPersons;
-(void)getManagers;
@end
