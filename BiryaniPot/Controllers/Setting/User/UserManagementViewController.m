//
//  EmployeeViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/22/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "UserManagementViewController.h"
#import "AddUserViewController.h"
#import "UserTableViewCell.h"
#import "UserTableViewCellHeader.h"
#import "User.h"
#import "Constants.h"

@interface UserManagementViewController ()

@end

@implementation UserManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initComponents];
}

-(void)initComponents
{
    self.addNewMemberButton.layer.cornerRadius = 5;
    self.addNewMemberButton.layer.borderWidth = 1;
    self.addNewMemberButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, 140, 40);
    gradient.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient.locations = @[@(0), @(1)];gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    gradient.cornerRadius = 5;
    [[self.addNewMemberButton layer] addSublayer:gradient];
    
    [self.userTableView registerNib:[UINib nibWithNibName:@"UserTableViewCellHeader" bundle:nil] forCellReuseIdentifier:@"userCellHeader"];
    [self.userTableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil] forCellReuseIdentifier:@"userCell"];
    
    self.userArray = [[NSMutableArray alloc]init];
}

-(void)viewDidAppear:(BOOL)animated
{
    @try
    {
        [self getManagers];
    }@catch(NSException *e)
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Unable to get managers"];
        NSLog(@"%@ %@", e.name, e.reason);
    }
    
    @try
    {
        [self getDeliveryPersons];
    }@catch(NSException *e)
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Unable to get delivery persons"];
        NSLog(@"%@ %@", e.name, e.reason);
    }
    @finally
    {
        [_userTableView reloadData];
    }
}

-(void)getManagers
{
    [_userArray removeAllObjects];
    
    NSURL *managerURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?loc_id=%@",Constants.GET_MANAGER_URL, Constants.LOCATION_ID]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:managerURL];
    NSError *error = nil;
    NSDictionary *orderList = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    NSDictionary *managersDictionary = [orderList objectForKey:@"managersList"];
    
    for (NSDictionary *managerDictionary in managersDictionary)
    {
        User *user = [[User alloc]init];
        user.userId = [managerDictionary objectForKey:@"managerId"];
        user.name = [managerDictionary objectForKey:@"managerName"];
        user.role = [[managerDictionary objectForKeyedSubscript:@"role"] objectForKey:@"typeName"];
        user.mobile = [managerDictionary objectForKey:@"managerMobile"];
        user.phone = @"";
        user.email = [managerDictionary objectForKey:@"managerEmail"];
        user.profilePictureURL = [managerDictionary objectForKey:@"imageURL"];
        
        [_userArray addObject:user];
    }
}

-(void)getDeliveryPersons
{
    NSURL *deliveryPersonURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?loc_id=%@",Constants.GET_DELIVERY_PERSON_URL, Constants.LOCATION_ID]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:deliveryPersonURL];
    NSError *error = nil;
    NSDictionary *deliveryPersonsDictionary = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    
    for (NSDictionary *deliveryPersonDictionary in deliveryPersonsDictionary)
    {
        User *user = [[User alloc]init];
        user.userId = [deliveryPersonDictionary objectForKey:@"dboyId"];
        user.name = [deliveryPersonDictionary objectForKey:@"dboyName"];
        user.role = @"Delivery Person";
        user.mobile = [deliveryPersonDictionary objectForKey:@"dboyMobile"];
        user.phone = @"";
        user.email = [deliveryPersonDictionary objectForKey:@"dboyEmail"];
        user.profilePictureURL = [deliveryPersonDictionary objectForKey:@"dboyImgUrl"];
        user.licenseNumber = [deliveryPersonDictionary objectForKey:@"licenseNumber"];
        
        [_userArray addObject:user];
    }
    
}

- (IBAction)addNewMemberButtonClicked:(id)sender {
    AddUserViewController * addUserViewController = [[AddUserViewController alloc]init];
    addUserViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    addUserViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    addUserViewController.delegate = self;
    [self presentViewController:addUserViewController animated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    User * user = _userArray[indexPath.row];
    cell.deleteButton.tag = indexPath.row;
    [cell setCellData:user withSelectedIndex:indexPath.row];
    cell.delegate = self;
    
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *userId = [NSString stringWithFormat:@"%@", [_appDelegate.userDefaults objectForKey:@"userId"]];
    
    if([[NSString stringWithFormat:@"%@", user.userId] isEqualToString:userId])
    {
        cell.deleteButton.hidden = TRUE;
    }
    else
    {
        cell.deleteButton.hidden = FALSE;
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UserTableViewCellHeader *cell = [tableView dequeueReusableCellWithIdentifier:@"userCellHeader"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
@end
