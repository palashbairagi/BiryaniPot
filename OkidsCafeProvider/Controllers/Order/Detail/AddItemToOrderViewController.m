//
//  AddItemToOrderViewController.m
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 1/21/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "AddItemToOrderViewController.h"
#import "OrderDetailTableViewCell.h"
#import "Category.h"
#import "Item.h"
#import "Constants.h"

@interface AddItemToOrderViewController ()

@end

@implementation AddItemToOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_itemTableView registerNib:[UINib nibWithNibName:@"OrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"itemCell"];
    
    [self initComponents];
}

-(void)initComponents
{
    [_backButton setTitle:[NSString stringWithFormat:@"%C", 0xf060] forState:UIControlStateNormal];
    [_backButton setTitle:[NSString stringWithFormat:@"%C", 0xf060] forState:UIControlStateHighlighted];
    
    Order *order = _delegate.order;
    
    _orderNo.text = order.orderNo;
    _customerName.text = order.customerName;
    _contactNo.text = order.contactNumber;
    
    _itemCount.text = [NSString stringWithFormat:@"%d Items", _delegate.noOfItems];
    _total.text = [NSString stringWithFormat:@"%@%.2f", AppConfig.currencySymbol, [order.grandTotal floatValue]];
    
    _revisedItemCount.text = [NSString stringWithFormat:@"%d Items", _delegate.noOfItems];
    _revisedItemTotal.text = [NSString stringWithFormat:@"%@%.2f", AppConfig.currencySymbol, [_delegate getTotal]];

    _categoryArray = [[NSMutableArray alloc]init];
    _itemArray1 = [[NSMutableArray alloc]init];
    
    [self getCategory];
}

-(void)getCategory
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        [_categoryArray removeAllObjects];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?loc_id=%@&filterout=0", Constants.GET_CATEGORIES_URL, Constants.LOCATION_ID]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
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
            
            NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            DebugLog(@"%@", resultDictionary);
            
            NSArray *categoriesArray= [resultDictionary objectForKey:@"categories"];
            
            for(NSDictionary *categoryDictionary in categoriesArray)
            {
                Category *category = [[Category alloc]init];
                category.categoryId = [categoryDictionary objectForKey:@"categoryId"];
                category.categoryName = [categoryDictionary objectForKey:@"categoryName"];
                category.imageURL = [categoryDictionary objectForKey:@"categoryUrl"];
                category.isNonVeg = [categoryDictionary objectForKey:@"isNonVegSupported"];
                
                [_categoryArray addObject:category];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_categoryTableView reloadData];
                [overlayView dismiss:YES];
            });
            
        }];
        
        [postDataTask resume];
        
    }@catch(NSException *e)
    {
        DebugLog(@"AddItemToOrderViewController [getCategory]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
    }
    @finally
    {
        [overlayView dismiss:YES];
    }
}

-(void)getItem: (NSString *)categoryId
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        [_itemArray1 removeAllObjects];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?category_id=%@", Constants.GET_ITEMS_BY_CATEGORY_URL, categoryId]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
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
            
            NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            DebugLog(@"%@", resultDictionary);
            
            NSArray *itemArray = [resultDictionary objectForKey:@"items"];
            
            for(NSDictionary *itemDictionary in itemArray)
            {
                Item *item = [[Item alloc]init];
                item.itemId = [itemDictionary objectForKey:@"itemId"];
                item.name = [itemDictionary objectForKey:@"itemName"];
                item.price = [NSString stringWithFormat:@"%@", [[itemDictionary objectForKey:@"price"] objectForKey:@"amount"]];
                item.discount = [NSString stringWithFormat:@"%@", [itemDictionary objectForKey:@"discount"]];
                item.imageURL = [itemDictionary objectForKey:@"itemImageUrl"];
                item.detail = [itemDictionary objectForKey:@"itemDescription"];
                item.itemTypeId = [itemDictionary objectForKey:@"itemTypeId"];
                
                if([itemDictionary objectForKey:@"isVeg"] == NULL)
                {
                    item.isVeg = FALSE;
                }
                else if(([[itemDictionary objectForKey:@"isVeg"] intValue] == 1))
                {
                    item.isVeg = TRUE;
                }
                else item.isVeg = FALSE;
                
                if([itemDictionary objectForKey:@"spiceSupported"] == NULL)
                {
                    item.isSpiceSupported = FALSE;
                }
                else if(([[itemDictionary objectForKey:@"spiceSupported"]intValue] == 1))
                {
                    item.isSpiceSupported = TRUE;
                }
                else item.isSpiceSupported = FALSE;
                
                BOOL found = FALSE;
                
                for (int i = 0; i < _invoiceItemArray.count; i++)
                {
                    Item *invoiceItem = _invoiceItemArray[i];
                    
                    if ([invoiceItem.itemId intValue] == [item.itemId intValue])
                    {
                        [_itemArray1 addObject:invoiceItem];
                        found = TRUE;
                    }
                }
                
                if (!found)
                {
                    [_itemArray1 addObject:item];
                }
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_itemTableView reloadData];
                
                if (_itemArray1.count > 0)
                {
                    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
                    [_itemTableView selectRowAtIndexPath:index animated:true scrollPosition:UITableViewScrollPositionNone];
                    [self tableView:_itemTableView didSelectRowAtIndexPath:index];
                }
                
                [overlayView dismiss:YES];
                
            });
            
        }];
        
        [postDataTask resume];
        
    }@catch(NSException *e)
    {
        DebugLog(@"AddItemToOrderViewController [getItem]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
    }
    @finally
    {
        [overlayView dismiss:YES];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_itemTableView == tableView)return _itemArray1.count;
    else return _categoryArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _itemTableView)
    {
        OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
        Item *item = _itemArray1[indexPath.row];
        [cell setCellData:item isQueue:_delegate.isQueue isPreparing:_delegate.isPreparing];
        cell.delegate = _delegate;
        cell.addItemDelegate = self;
        cell.negativeButton.tag = indexPath.row;
        cell.positiveButton.tag = indexPath.row;
        cell.spiceLevel.tag = indexPath.row;

        return cell;
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        Category *category = _categoryArray[indexPath.row];
        cell.textLabel.text = category.categoryName;
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _categoryTableView)
    {
        Category *category =  _categoryArray[indexPath.row];
        [self getItem:category.categoryId];
    }
}

- (IBAction)backButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate.itemTable reloadData];
        });
    }];
}

@end
