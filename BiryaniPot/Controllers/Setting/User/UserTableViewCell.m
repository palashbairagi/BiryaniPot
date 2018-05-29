//
//  UserTableViewCell.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/27/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_deleteButton setTitle:[NSString stringWithFormat:@"%C", 0xf1f8] forState:UIControlStateNormal];
    
    [_deleteButton setTitle:[NSString stringWithFormat:@"%C", 0xf1f8] forState:UIControlStateHighlighted];
    _profilePictureQueue = [[NSOperationQueue alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setCellData:(User *)user withSelectedIndex:(NSInteger)selectedIndex
{
    _name.text = user.name;
    _role.text = user.role;
    _mobile.text = user.mobile;
    _licenceNo.text = user.licenseNumber;
    _email.text = user.email;
    _deleteButton.titleLabel.text = [NSString stringWithFormat:@"%C", 0xf1f8];
    
    if (user.profilePicture == nil )
    {
        NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
            
            UIImage * image = [UIImage imageNamed:@"dp"];
            NSData * imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.profilePictureURL]];
            
            if (imgData != NULL)
            {
                image = [UIImage imageWithData:imgData];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_profilePicture setImage:image];
            });
            
        }];
        
        [_profilePictureQueue addOperation:op];
    }
    else
    {
        _profilePicture.image = user.profilePicture;
    }
}

- (IBAction)deleteButtonClicked:(UIButton *)sender
{
    User *user = _delegate.userArray[sender.tag];
    
    if ([user.role isEqualToString:@"Delivery Person"])
    {
        [self deleteDeliveryPerson:user];
    }
    else if([user.role isEqualToString:@"Manager"] || [user.role isEqualToString:@"Partner"])
    {
        [self deleteManager:user];
    }
    else
    {
        [Validation showSimpleAlertOnViewController:_delegate withTitle:@"Alert" andMessage:@"Unable to Delete"];
    }
    
}

-(void)deleteDeliveryPerson:(User *)user
{
    
    NSString *post = [NSString stringWithFormat:@"dboy_id=%@&dboy_name=%@&mobile=%@&img_url=%@&email=%@&is_active=0&loc_id=%@", user.userId, user.name, user.mobile, user.profilePictureURL, user.email, Constants.LOCATION_ID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.DELETE_DELIVERY_PERSON_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate getManagers];
            [_delegate getDeliveryPersons];
            [_delegate.userTableView reloadData];
        });
        
    }];
    [postDataTask resume];
}

-(void)deleteManager:(User *)user
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?username=%@&loc_id=%@", Constants.DELETE_MANAGER_URL, user.email ,Constants.LOCATION_ID]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSDictionary *status = [result objectForKey:@"status"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([status isEqual:[NSNumber numberWithInt:1]])
            {
                [_delegate getManagers];
                [_delegate getDeliveryPersons];
                [_delegate.userTableView reloadData];
            }
            else
            {
                [Validation showSimpleAlertOnViewController:_delegate withTitle:@"Error" andMessage:@"Unable to delete"];
            }
        });
        
    }];
    
    [postDataTask resume];
}

@end
