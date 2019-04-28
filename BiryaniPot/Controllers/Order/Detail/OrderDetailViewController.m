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

-(void)getItemsList
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        [_itemArray removeAllObjects];
        [_updatedItemArray removeAllObjects];
        
        NSURL *itemsURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?order_id=%@",Constants.GET_ITEMS_BY_ORDER_URL, _order.orderNo]];
        NSError *error = nil;
        NSData *responseJSONData = [NSData dataWithContentsOfURL:itemsURL options:kNilOptions error:&error];
        
        DebugLog(@"Request %@ ",itemsURL);
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        NSDictionary *orderDictionary = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        DebugLog(@"%@", orderDictionary);
        
        NSString *cName = _order.customerName;
        NSString *cNo = _order.contactNumber;
        
        _order = [[Order alloc]init];
        _order.orderNo = _orderNo.text;
        _order.customerName = cName;
        _order.contactNumber = cNo;
        _order.deliveryFee = [orderDictionary objectForKey:@"deliveryFee"];
        _order.tip = [orderDictionary objectForKey:@"tip"];
        _order.grandTotal = [NSString stringWithFormat:@"%.2f", [[orderDictionary objectForKey:@"grandTotal"] floatValue]];
        _order.orderTime = [orderDictionary objectForKey:@"orderDate"];
        _order.deliveryType = [orderDictionary objectForKey:@"orderType"];
        _order.subTotal = [NSString stringWithFormat:@"%.2f", [[orderDictionary objectForKey:@"subTotal"] floatValue]];
        _order.tax = [NSString stringWithFormat:@"%.2f", [[orderDictionary objectForKey:@"tax"] floatValue]];
        _order.paymentType = [NSString stringWithFormat:@"%@", [orderDictionary objectForKey:@"paymentType"]];
        
        if ([_order.deliveryType isEqual:@"Pickup"])
        {
            _address.hidden = TRUE;
        }
        
        if ([_order.paymentType intValue] == 1)
        {
            _paymentTypeImageView.image = [UIImage imageNamed:@"cash"];
        }
        else
        {
            _paymentTypeImageView.image = [UIImage imageNamed:@"card"];
        }
        
        NSArray *itemsArray = [orderDictionary objectForKey:@"items"];
        
        for (NSDictionary *itemDictionary in itemsArray)
        {
            NSString *itemId = [itemDictionary objectForKey:@"itemId"];
            NSString *itemName = [itemDictionary objectForKey:@"itemName"];
            NSString *price = [[itemDictionary objectForKey:@"price"] objectForKey:@"amount"];
            NSString *quantity = [itemDictionary objectForKey:@"quantity"];
            NSString *spiceLevel = [itemDictionary objectForKey:@"spiceLevel"];
            BOOL isSpiceSupported = [[itemDictionary objectForKey:@"spiceSupported"] boolValue];
            
            Item *item = [[Item alloc]init];
            item.itemId = itemId;
            item.name = itemName;
            item.price = price;
            item.quantity = [NSString stringWithFormat:@"%@", quantity];
            item.spiceLevel = spiceLevel;
            item.isSpiceSupported = isSpiceSupported;
            
            [_itemArray addObject:item];
            [_updatedItemArray addObject:[item copy]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [overlayView dismiss:YES];
        });
        
    }@catch(NSException *e)
    {
        DebugLog(@"OrderDetailViewController [getItemsList]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
    }
    @finally
    {
        [overlayView dismiss:YES];
    }
}

-(void) removeItems
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        NSString *orderNo = _order.orderNo;
        
        for (Item *item in _itemArray)
        {
            NSString *statementType = @"delete";
            NSString *itemId = item.itemId;
            NSString *itemName = item.name;
            NSString *quantity = item.quantity;
            NSString *spiceId = @"";
            
            if([item.spiceLevel isEqualToString:@"Low"])
            {
                spiceId = @"1";
            }
            else if([item.spiceLevel isEqualToString:@"Medium"])
            {
                spiceId = @"2";
            }
            else if([item.spiceLevel isEqualToString:@"High"])
            {
                spiceId = @"3";
            }
            
            NSString *post = [NSString stringWithFormat:@"order_id=%@&item_id=%@&item_name=%@&qty=%@&spice_id=%@&statement_type=%@", orderNo, itemId, itemName, quantity, spiceId, statementType];
            
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.UPDATE_ORDER_DETAIL]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                DebugLog(@"Request %@ Response %@", request, response);
                [overlayView setModeAndProgressWithStateOfTask:postDataTask];
                
                if (error != nil)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                        [overlayView dismiss:YES];
                    });
                    return;
                }
                
                NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                if (error != nil)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                        [overlayView dismiss:YES];
                    });
                    return;
                }
                
                DebugLog(@"%@", resultDictionary);
                
                if ([[resultDictionary objectForKey:@"status"] integerValue] != 1)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSString *message = [NSString stringWithFormat:@"Unable to perform operation on %@", itemName];
                        
                        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:message];
                        
                    });
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [overlayView dismiss:YES];
                });
                
            }];
            
            [postDataTask resume];
            
        }
    }@catch(NSException *e)
    {
        DebugLog(@"OrderDetailViewController [removeItems]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
    }
    @finally
    {
        [overlayView dismiss:YES];
        [self removeItems];
    }
}

-(void) updateOrderDetails
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        NSString *orderNo = _order.orderNo;
        
        for (Item *item in _updatedItemArray)
        {
            NSString *statementType = @"insert";
            NSString *itemId = item.itemId;
            NSString *itemName = item.name;
            NSString *quantity = item.quantity;
            NSString *spiceId = @"";
            
            if([item.spiceLevel isEqualToString:@"Low"])
            {
                spiceId = @"1";
            }
            else if([item.spiceLevel isEqualToString:@"Medium"])
            {
                spiceId = @"2";
            }
            else if([item.spiceLevel isEqualToString:@"High"])
            {
                spiceId = @"3";
            }
            
            for (Item *existingItem in _itemArray)
            {
                if ([existingItem.itemId intValue] == [item.itemId intValue])
                {
                    statementType = @"update";
                    [_itemArray removeObject:existingItem];
                    break;
                }
            }
            
            NSString *post = [NSString stringWithFormat:@"order_id=%@&item_id=%@&item_name=%@&qty=%@&spice_id=%@&statement_type=%@", orderNo, itemId, itemName, quantity, spiceId, statementType];
            
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.UPDATE_ORDER_DETAIL]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                DebugLog(@"Request %@ Response %@", request, response);
                [overlayView setModeAndProgressWithStateOfTask:postDataTask];
                
                if (error != nil)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                        [overlayView dismiss:YES];
                    });
                    return;
                }
                
                NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                if (error != nil)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                        [overlayView dismiss:YES];
                    });
                    return;
                }
                
                DebugLog(@"%@", resultDictionary);
                
                if ([[resultDictionary objectForKey:@"status"] integerValue] != 1)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSString *message = [NSString stringWithFormat:@"Unable to perform operation on %@", itemName];
                        
                        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:message];
                        
                    });
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [overlayView dismiss:YES];
                });
                
            }];
            
            [postDataTask resume];
        }
        
    }@catch(NSException *e)
    {
        DebugLog(@"OrderDetailViewController [updateOrderDetails]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
    }
    @finally
    {
        [overlayView dismiss:YES];
        [self removeItems];
    }
}

-(void)cancelOrder
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
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
            
            DebugLog(@"Request %@ Response %@", request, response);
            [overlayView setModeAndProgressWithStateOfTask:postDataTask];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            DebugLog(@"%@", resultDic);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[resultDic objectForKey:@"status"] intValue] == 1)
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirmation" message:@"Order Cancelled" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *close = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                        
                        [_delegate loadData];
                        [overlayView dismiss:YES];
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                    }];
                    
                    [alertController addAction:close];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else
                {
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to cancel"];
                }
                
            });
            
        }];
        
        [postDataTask resume];
    
    }@catch(NSException *e)
    {
        DebugLog(@"OrderDetailViewController [cancelOrder]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
}

-(void) initComponents
{
    if (_isQueue)
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
    else if(_isPreparing)
    {
        _addItemButton.hidden = TRUE; // make false
        _saveButton.hidden = TRUE; // make false
        _cancelButton.hidden = FALSE; // make true
    
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
    _updatedItemArray = [[NSMutableArray alloc] init];
    
    [self.itemTable registerNib:[UINib nibWithNibName:@"OrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"itemCell"];
    
    _orderNo.text = _order.orderNo;
    _customerName.text = _order.customerName;
    _contactNumber.text = _order.contactNumber;
    _address.text = _order.address;
    _itemCount.text = _order.itemCount;
    
    [self getItemsList];
    [self setOrderDetails];
}

-(float) getTotal
{
    float subTotal = 0;
    float deliveryFee = [_order.deliveryFee floatValue];
    float tip = [_order.tip floatValue];
    float tax = 6.2;
    float total = 0;
    int count = 0;
    
    for (int i = 0; i < _updatedItemArray.count; i++)
    {
        Item *item = _updatedItemArray[i];
        
        subTotal += [item.price floatValue] * [item.quantity intValue];
        
        count += [item.quantity intValue];
    }
    
    tax = (subTotal/100) * tax;
    total = subTotal + deliveryFee + tip + tax;
    
    _subTotal.text = [NSString stringWithFormat:@"$%.2f", subTotal];
    _tax.text = [NSString stringWithFormat:@"$%.2f", tax];
    _grandTotal.text = [NSString stringWithFormat:@"$%.2f", total];
    
    _itemCount.text = [NSString stringWithFormat:@"%d", count];
    
    _noOfItems = count;
    
    return total;
}

-(void)setOrderDetails
{
    _subTotal.text = [NSString stringWithFormat:@"$%@", _order.subTotal];
    _tax.text = [NSString stringWithFormat:@"$%@", _order.tax];
    _tip.text = [NSString stringWithFormat:@"$%@", _order.tip];
    _deliveryFee.text = [NSString stringWithFormat:@"$%@", _order.deliveryFee];
    _grandTotal.text = [NSString stringWithFormat:@"$%@", _order.grandTotal];
    
    _deliveryType.text = _order.deliveryType;
}

- (IBAction)addItemButtonClicked:(id)sender
{
    AddItemToOrderViewController *addItemVC = [[AddItemToOrderViewController alloc]init];
    addItemVC.modalPresentationStyle = UIModalPresentationFormSheet;
    addItemVC.modalTransitionStyle = UIModalPresentationNone;
    addItemVC.preferredContentSize = CGSizeMake(850, 670);
    addItemVC.invoiceItemArray = _updatedItemArray;
    addItemVC.delegate = self;
    
    [self presentViewController:addItemVC animated:YES completion:nil];
    
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_itemArray.count-1 inSection:0];
    //[_itemTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    //[_itemTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (IBAction)saveButtonClicked:(id)sender
{
    [self updateOrderDetails];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirmation" message:@"Do you really want to cancel?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        
        if ([_order.paymentType intValue] == 1)
        {
            [self cancelOrder];
        }
        else
        {
            [self getPaymentDetail];
        }
        
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
    if (_updatedItemArray.count > 6)
    {
        _scrollMessageLabel.hidden = FALSE;
    }
    else
    {
        _scrollMessageLabel.hidden = TRUE;
    }
    
    return _updatedItemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
    Item * item = _updatedItemArray[indexPath.row];
    [cell setCellData:item isQueue:_isQueue isPreparing:_isPreparing];
    cell.delegate = self;
    cell.addItemDelegate = NULL;
    cell.negativeButton.tag = indexPath.row;
    cell.positiveButton.tag = indexPath.row;
    cell.spiceLevel.tag = indexPath.row;
    
    return cell;
}

-(void) getPaymentDetail
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        NSString *orderNo = _order.orderNo;
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?orderid=%@", Constants.GET_PAYMENT_DETAIL_URL, orderNo]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        [request setHTTPMethod:@"GET"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            DebugLog(@"Request %@ Response %@", request, response);
            [overlayView setModeAndProgressWithStateOfTask:dataTask];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            DebugLog(@"%@", resultDic);
        
            NSArray *paymentsDetailArray = [resultDic objectForKey:@"payments"];
            
            if(paymentsDetailArray.count == 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"No Payment Detail Found"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            int isCaptured = [[paymentsDetailArray[0] objectForKey:@"isCaptured"] intValue];
            
            if(!isCaptured)
            {
                _merchantId = [paymentsDetailArray[0] objectForKey:@"merchantId"];
                _reference = [paymentsDetailArray[0] objectForKey:@"retrievalReference"];
                dispatch_async(dispatch_get_main_queue(), ^{
                        [self voidPayment];
                        [overlayView dismiss:YES];
                    });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Payment Captured, can't initiate refund"];
                    [overlayView dismiss:YES];
                });
                return;
            }
    }];
    
    [dataTask resume];
        
    }@catch(NSException *e)
    {
        DebugLog(@"OrderDetailViewController [getPaymentDetail]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
        [overlayView dismiss:YES];
    }
}

-(void) voidPayment
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        NSDictionary *headers = @{ @"Authorization": Constants.AUTHORIZATION_STRING,
                                   @"Content-Type": @"application/json"
                                  };
    
        NSDictionary *parameters = @{ @"retref": _reference,
                                      @"merchid": _merchantId };
    
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.REFUND_URL]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        [request setHTTPMethod:@"PUT"];
        [request setAllHTTPHeaderFields:headers];
        [request setHTTPBody:postData];
    
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            DebugLog(@"Request %@ Response %@", request, response);
            [overlayView setModeAndProgressWithStateOfTask:dataTask];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            DebugLog(@"%@", resultDic);
            
            NSString *state = [resultDic objectForKey:@"respstat"];
            
            if ([state isEqualToString:@"A"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self cancelOrder];
                    [overlayView dismiss:YES];
                });
            }
            else
            {
                NSString *message = [resultDic objectForKey:@"resptext"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:message];
                    [overlayView dismiss:YES];
                });
            }
            
        }];
    
        [dataTask resume];
    }@catch(NSException *e)
    {
        DebugLog(@"OrderDetailViewController [voidPayment]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
        [overlayView dismiss:YES];
    }
}

- (IBAction)printButtonClicked:(id)sender
{
    Print *print = [[Print alloc] init];
    print.order = _order;
    print.itemArray = _itemArray;
    
    [Constants printInvoice:print];
}

- (IBAction)closeButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
