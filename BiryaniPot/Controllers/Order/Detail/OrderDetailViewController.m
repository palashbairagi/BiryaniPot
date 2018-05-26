//
//  OrderDetailViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/29/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailTableViewCell.h"
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
    if(_isQueue || _isPreparing)
    {
        _addItemButton.hidden = FALSE;
        _saveButton.hidden = FALSE;
        _cancelButton.hidden = FALSE;
    
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
    }
    else
    {
        _addItemButton.hidden = TRUE;
        _saveButton.hidden = TRUE;
        _cancelButton.hidden = TRUE;
    }
    
    _itemArray = [[NSMutableArray alloc]init];
    
    [self.itemTable registerNib:[UINib nibWithNibName:@"OrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"itemCell"];
    
    _orderNo.text = _order.orderNo;
    _customerName.text = _order.customerName;
    _contactNumber.text = _order.contactNumber;
    
    [self getItemsList];
    [self setOrderDetails];
}

-(void)getItemsList
{
    NSURL *itemsURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?order_id=%@",Constants.GET_ITEMS_BY_ORDER_URL, _order.orderNo]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:itemsURL];
    NSError *error = nil;
    NSDictionary *orderDictionary = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    
    _order = [[Order alloc]init];
    _order.orderNo = _orderNo.text;
    _order.deliveryFee = [orderDictionary objectForKey:@"deliveryFee"];
    _order.tip = [orderDictionary objectForKey:@"tip"];
    _order.grandTotal = [NSString stringWithFormat:@"%.2f", [[orderDictionary objectForKey:@"grandTotal"] floatValue]];
    _order.orderTime = [orderDictionary objectForKey:@"orderDate"];
    _order.deliveryType = [orderDictionary objectForKey:@"orderType"];
    _order.subTotal = [orderDictionary objectForKey:@"subTotal"];
    _order.tax = [NSString stringWithFormat:@"%.2f", [[orderDictionary objectForKey:@"tax"] floatValue]];
    
    NSArray *itemsArray = [orderDictionary objectForKey:@"items"];
    
    for (NSDictionary *itemDictionary in itemsArray)
    {
        NSString *itemId = [itemDictionary objectForKey:@"itemId"];
        NSString *itemName = [itemDictionary objectForKey:@"itemName"];
        NSString *price = [[itemDictionary objectForKey:@"price"] objectForKey:@"amount"];
        NSString *quantity = [itemDictionary objectForKey:@"quantity"];
        NSString *spiceLevel = [itemDictionary objectForKey:@"spiceLevel"];
        NSString *isSpiceSupported = [itemDictionary objectForKey:@"spiceSupported"];
        
        Item *item = [[Item alloc]init];
        item.itemId = itemId;
        item.name = itemName;
        item.price = price;
        item.quantity = [NSString stringWithFormat:@"%@", quantity];
        item.spiceLevel = spiceLevel;
        item.isSpiceSupported = isSpiceSupported;
        
        [_itemArray addObject:item];
    }
}

-(void)setOrderDetails
{
    _subTotal.text = [NSString stringWithFormat:@"$%@", _order.subTotal];
    _tax.text = [NSString stringWithFormat:@"$%@", _order.tax];
    _tip.text = [NSString stringWithFormat:@"$%@", _order.tip];
    _deliveryFee.text = [NSString stringWithFormat:@"$%@", _order.deliveryFee];
    _grandTotal.text = [NSString stringWithFormat:@"$%@", _order.grandTotal];
    
    _itemCount.text = [NSString stringWithFormat:@"%lu", _itemArray.count];
    _deliveryType.text = _order.deliveryType;
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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirmation" message:@"Do you really want to cancel?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self cancelOrder];
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:yes];
    [alertController addAction:no];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
    Item * item = _itemArray[indexPath.row];
    [cell setCellData:item isQueue:_isQueue isPreparing:_isPreparing];
    cell.delegate = self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

-(void)cancelOrder
{
    NSString *orderNo = _order.orderNo;
    
    NSString *post = [NSString stringWithFormat:@"order_id=%@", orderNo];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil]; 
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.CANCEL_ORDER_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate loadData];
        });
        
    }];
    [postDataTask resume];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
