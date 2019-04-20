//
//  EmployeeViewController.m
// OkidsCafeProvider
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
    [self getManagers];
    [self getDeliveryPersons];
    [_userTableView reloadData];
}

-(void)getManagers
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        [_userArray removeAllObjects];
        
        NSURL *managerURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?loc_id=%@",Constants.GET_MANAGER_URL, Constants.LOCATION_ID]];
        NSData *responseJSONData = [NSData dataWithContentsOfURL:managerURL];
        NSError *error = nil;
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        DebugLog(@"%@", result);
        
        NSDictionary *managersDictionary = [result objectForKey:@"managersList"];
        
        for (NSDictionary *managerDictionary in managersDictionary)
        {
            User *user = [[User alloc]init];
            user.userId = [managerDictionary objectForKey:@"managerId"];
            user.name = [managerDictionary objectForKey:@"managerName"];
            user.role = [[managerDictionary objectForKeyedSubscript:@"role"] objectForKey:@"typeName"];
            user.mobile = [managerDictionary objectForKey:@"phone"];
            user.phone = @"";
            user.email = [managerDictionary objectForKey:@"managerEmail"];
            user.profilePictureURL = [managerDictionary objectForKey:@"imageURL"];
            
            if([[managerDictionary objectForKey:@"active"] boolValue])
            {
                [_userArray addObject:user];
                
                if([user.role isEqualToString:@"Manager"])
                {
                    _managerCount++;
                }
                else if([user.role isEqualToString:@"Partner"])
                {
                    _partnerCount++;
                }
            }
        }
        [overlayView dismiss:YES];
    }
    @catch(NSException *e)
    {
        DebugLog(@"UserManagementViewController [getManagers]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
}

-(void)getDeliveryPersons
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        NSURL *deliveryPersonURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?loc_id=%@",Constants.GET_DELIVERY_PERSON_URL, Constants.LOCATION_ID]];
        NSError *error = nil;
        NSData *responseJSONData = [NSData dataWithContentsOfURL:deliveryPersonURL];
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        NSDictionary *deliveryPersonsDictionary = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        DebugLog(@"%@", deliveryPersonsDictionary);
        
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
        [overlayView dismiss:YES];
    }
    @catch(NSException *e)
    {
        DebugLog(@"UserManagementViewController [getDeliveryPerson]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
        [overlayView dismiss:YES];
    }
    @finally
    {
       
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
