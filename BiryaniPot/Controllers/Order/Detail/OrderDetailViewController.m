//
//  OrderDetailViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/29/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailTableViewCell.h"
#import "CancelViewController.h"
#import "AddItemToOrderViewController.h"
#import "Item.h"
#import "Constants.h"

@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initComponents];
}

-(void) initComponents
{
    self.addItemButton.layer.cornerRadius = 5;
    self.addItemButton.layer.borderWidth = 1;
    self.addItemButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient1 = [CAGradientLayer layer];
    gradient1.frame = CGRectMake(0, 0, 100, 40);
    gradient1.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient1.locations = @[@(0), @(1)];gradient1.startPoint = CGPointMake(0.5, 0);
    gradient1.endPoint = CGPointMake(0.5, 1);
    gradient1.cornerRadius = 5;
    [[self.addItemButton layer] addSublayer:gradient1];
    
    self.saveButton.layer.cornerRadius = 5;
    self.saveButton.layer.borderWidth = 1;
    self.saveButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, 100, 40);
    gradient.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient.locations = @[@(0), @(1)];gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    gradient.cornerRadius = 5;
    [[self.saveButton layer] addSublayer:gradient];
    
    self.cancelButton.layer.cornerRadius = 5;
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _itemArray = [[NSMutableArray alloc]init];
    
    [self.itemTable registerNib:[UINib nibWithNibName:@"OrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"itemCell"];
    
    _orderNo.text = _order.orderNo;
    _customerName.text = _order.customerName;
    _contactNumber.text = _order.contactNumber;
    
    [self getItemsList];
}

-(void)getItemsList
{
    NSURL *itemsURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?order_id=%@",Constants.GET_ITEMS_BY_ORDER_URL, _order.orderNo]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:itemsURL];
    NSError *error = nil;
    NSDictionary *itemsDictionary = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    
    for (NSDictionary *itemDictionary in itemsDictionary)
    {
        NSString *grandTotal = [itemDictionary objectForKey:@"grandTotal"];
        NSString *itemName = [itemDictionary objectForKey:@"itemName"];
        NSString *itemType = [itemDictionary objectForKey:@"itemType"];
      //  NSString *orderId = [itemDictionary objectForKey:@"orderId"];
        NSString *price = [itemDictionary objectForKey:@"price"];
        NSString *quantity = [itemDictionary objectForKey:@"quantity"];
        NSString *spiceLevel = [itemDictionary objectForKey:@"spiceLevel"];
        NSString *taxName = [itemDictionary objectForKey:@"taxName"];
        NSString *taxPercentage = [itemDictionary objectForKey:@"taxPercentage"];
        NSString *total = [itemDictionary objectForKey:@"total"];
        
        Item *item = [[Item alloc]init];
        item.grandTotal = grandTotal;
        item.name = itemName;
        item.type = itemType;
        item.price = price;
        item.quantity = [NSString stringWithFormat:@"%@", quantity];
        item.spiceLevel = spiceLevel;
        item.taxName = taxName;
        item.taxPercent = taxPercentage;
        item.total = total;
        
        [_itemArray addObject:item];
    }
}

- (IBAction)addItemButtonClicked:(id)sender
{
    AddItemToOrderViewController *addItemVC = [[AddItemToOrderViewController alloc]init];
    addItemVC.modalPresentationStyle = UIModalPresentationFormSheet;
    addItemVC.modalTransitionStyle = UIModalPresentationNone;
    addItemVC.preferredContentSize = CGSizeMake(720, 580);
    
    [self presentViewController:addItemVC animated:YES completion:nil];
    
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_itemArray.count-1 inSection:0];
    //[_itemTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    //[_itemTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (IBAction)saveButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    CancelViewController * cancelViewController = [[CancelViewController alloc]init];
    cancelViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    cancelViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    cancelViewController.preferredContentSize = CGSizeMake(400, 220);
    Order *order = [[Order alloc]init];
    order.orderNo = _orderNo.text;
    order.customerName = _customerName.text;
    cancelViewController.order = order;
    cancelViewController.delegate = self;
    [self presentViewController: cancelViewController animated:YES completion:nil];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemArray.count-1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
    Item * item = _itemArray[indexPath.row];
    [cell setCellData:item];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}


@end
