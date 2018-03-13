//
//  SelectDeliveryPersonViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/22/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "SelectDeliveryPersonViewController.h"
#import "Order.h"
#import "Constants.h"
#import "User.h"

@interface SelectDeliveryPersonViewController ()

@end

@implementation SelectDeliveryPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nameArray = [[NSMutableArray alloc]init];
    
    self.selectButton.layer.cornerRadius = 5;
    self.selectButton.layer.borderWidth = 1;
    self.selectButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient1 = [CAGradientLayer layer];
    gradient1.frame = CGRectMake(0, 0, 80, 30);
    gradient1.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient1.locations = @[@(0), @(1)];gradient1.startPoint = CGPointMake(0.5, 0);
    gradient1.endPoint = CGPointMake(0.5, 1);
    gradient1.cornerRadius = 5;
    [[self.selectButton layer] addSublayer:gradient1];
    
    [self getDeliveryPersons];
}

-(void)getDeliveryPersons
{
    NSURL *deliveryPersonURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?loc_id=1",Constants.GET_DELIVERY_PERSON_URL]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:deliveryPersonURL];
    NSError *error = nil;
    NSDictionary *deliveryPersonsDictionary = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];

    for (NSDictionary *deliveryPersonDictionary in deliveryPersonsDictionary)
    {
        
        NSString *dboyId = [deliveryPersonDictionary objectForKey:@"dboyId"];
        NSString *imgURL = [deliveryPersonDictionary objectForKey:@"dboyImgUrl"];
        NSString *dboyMobile = [deliveryPersonDictionary objectForKey:@"dboyMobile"];
        NSString *name = [deliveryPersonDictionary objectForKey:@"dboyName"];
        NSString *isActive = [deliveryPersonDictionary objectForKey:@"isActive"];
        NSString *isAvailable = [deliveryPersonDictionary objectForKey:@"isAvailable"];
        
        if ([isActive intValue] == 1 && [isAvailable intValue] == 1)
        {
            User *user = [[User alloc]init];
            user.userId = dboyId;
            user.name = name;
            user.profilePictureURL = imgURL;
            user.mobile = dboyMobile;
            
            [_nameArray addObject:user];
        }
    }

}

- (IBAction)selectButtonClicked:(id)sender
{
    User *user = [_nameArray objectAtIndex:[_pickerView selectedRowInComponent:0]];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _nameArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    User *user = _nameArray[row];
    return user.name;
}
@end
