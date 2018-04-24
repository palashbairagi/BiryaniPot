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
    NSDictionary *itemsDictionary = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    
    for (NSDictionary *itemDictionary in itemsDictionary)
    {
        NSString *grandTotal = [NSString stringWithFormat:@"%.2f", [[itemDictionary objectForKey:@"grandTotal"] floatValue] ];
        NSString *itemName = [itemDictionary objectForKey:@"itemName"];
        NSString *itemType = [itemDictionary objectForKey:@"itemType"];
        NSString *price = [itemDictionary objectForKey:@"price"];
        NSString *quantity = [itemDictionary objectForKey:@"itemQuantity"];
        NSString *taxName = [itemDictionary objectForKey:@"taxName"];
        NSString *subTotal = [itemDictionary objectForKey:@"subTotal"];
        NSString *tax = [NSString stringWithFormat:@"%.2f", [[itemDictionary objectForKey:@"tax"] floatValue]];
        NSString *total = [itemDictionary objectForKey:@"total"];
        NSString *deliveryFee = [itemDictionary objectForKey:@"deliveryFee"];
        
        Item *item = [[Item alloc]init];
        item.grandTotal = grandTotal;
        item.subTotal = subTotal;
        item.name = itemName;
        item.type = itemType;
        item.price = price;
        item.quantity = [NSString stringWithFormat:@"%@", quantity];
        item.taxName = taxName;
        item.tax = tax;
        item.deliveryFee = deliveryFee;
        item.total = total;
        
        [_itemArray addObject:item];
    }
}

-(void)setDetails
{
    _deliveryType.text = _delegate.orderType;
    _customerName.text = _delegate.email;
    _customerPhone.text = _delegate.contactNumber;
    
    Item *item = _itemArray[_itemArray.count-1];
    _subTotal.text = [NSString stringWithFormat:@"%@", item.subTotal];
    _tax.text = [NSString stringWithFormat:@"%@", item.tax];
    _deliveryFee.text = [NSString stringWithFormat:@"%@", item.deliveryFee];
    _total.text = [NSString stringWithFormat:@"%@", item.grandTotal];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemArray.count-1;
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


@end
