//
//  InvoiceViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 2/9/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "InvoiceViewController.h"
#import "InvoiceDetailTableViewCell.h"
#import "Item.h"

@interface InvoiceViewController ()

@end

@implementation InvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _orderNo.text = _delegate.orderNo;
    
    _itemArray = [[NSMutableArray alloc]init];
    
    [self.itemTableView registerNib:[UINib nibWithNibName:@"InvoiceDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"invoiceCell"];
    
    [self getItemsList];
    [self setDetails];
}

-(void)getItemsList
{
    NSURL *itemsURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?order_id=%@",Constants.GET_ITEMS_BY_ORDER_URL, _delegate.orderNo]];
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

-(void)setDetails
{
    _customerName.text = _delegate.email; 
    _customerPhone.text = _delegate.contactNumber;
    _paymentType.text = _delegate.paymentType;
    
    _orderDate.text = [self convertDate:_order.orderTime];
    _subTotal.text = [NSString stringWithFormat:@"$%@", _order.subTotal];
    _tax.text = [NSString stringWithFormat:@"$%@", _order.tax];
    _tip.text = [NSString stringWithFormat:@"$%@", _order.tip];
    _deliveryFee.text = [NSString stringWithFormat:@"$%@", _order.deliveryFee];
    _total.text = [NSString stringWithFormat:@"$%@", _order.grandTotal];
    
    _deliveryType.text = _order.deliveryType;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InvoiceDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"invoiceCell" forIndexPath:indexPath];
    Item * item = _itemArray[indexPath.row];
    cell.itemName.text = item.name;
    cell.quantity.text = [NSString stringWithFormat:@"X%@", item.quantity];
    cell.price.text = [NSString stringWithFormat:@"$%.2f", ([item.price floatValue] * [item.quantity intValue])];
    return cell;
}

- (IBAction)closeButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *)convertDate:(NSString *) dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MMM dd, yyyy"];
    return [dateFormatter1 stringFromDate:dateFromString];
}

@end
