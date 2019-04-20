//
//  AddRecommendedItemViewController.m
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 5/22/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "AddRecommendedItemViewController.h"
#import "Item.h"
#import "Category.h"

@interface AddRecommendedItemViewController ()

@end

@implementation AddRecommendedItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initComponents];
}

-(void) addRecommendedItem
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        NSIndexPath *indexPath = _itemTableView.indexPathForSelectedRow;
        
        if (indexPath == NULL || indexPath.row == -1)
        {
            [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Please select item"];
            [overlayView dismiss:YES];
            return;
        }
        
        Item *item = _itemArray[indexPath.row];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.ADD_RECOMMENDED_ITEMS_URL]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        NSString *postString = [NSString stringWithFormat:@"item_id=%@&rec_item_id=%@&loc_id=%@&statement_type=insert", _selectedItem.itemId, item.itemId, Constants.LOCATION_ID];
        
        NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            DebugLog(@"Request %@ Response %@", request, response);
            [overlayView setModeAndProgressWithStateOfTask:task];
            
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
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Successful" andMessage:@"Recommended Item Added"];
                    NSIndexPath *indexPath = _categoryTableView.indexPathForSelectedRow;
                    Category *category = _categoryArray[indexPath.row];
                    [self getItem:category.categoryId];
                    [self getRecommendedItem:_selectedItem];
                    [_delegate getRecommendedItem:_selectedItem];
                }
                else
                {
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Add"];
                }
                
                [overlayView dismiss:YES];
            });
        }];
        
        [task resume];
    }@catch(NSException *e)
    {
        DebugLog(@"AddRecommendedItemViewController [addRecommendedItem]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
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
        DebugLog(@"AddRecommendedItemViewController [getCategory]: %@ %@",e.name, e.reason);
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
        [_itemArray removeAllObjects];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?access_token=%@&category_id=%@&locationid=%@", Constants.GET_ITEMS_BY_CATEGORY_URL, Constants.ACCESS_TOKEN ,categoryId, Constants.LOCATION_ID]];
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
                item.pointsRequired = [NSString stringWithFormat:@"%@", [itemDictionary objectForKey:@"pointsRequired"]];
                
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
                
                for(Item *recItem in _recommendedItemArray)
                {
                    if ([recItem.itemId intValue] == [item.itemId intValue])
                    {
                        found = TRUE;
                        break;
                    }
                }
                
                if (!found && [_selectedItem.itemId intValue] != [item.itemId intValue])
                {
                    [_itemArray addObject:item];
                }
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_itemTableView reloadData];
                
                if (_itemArray.count > 0)
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
        DebugLog(@"AddRecommendedItemViewController [getItem]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
    }
    @finally
    {
        [overlayView dismiss:YES];
    }
}

-(void)getRecommendedItem: (Item *) item
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        [_recommendedItemArray removeAllObjects];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.GET_RECOMMENDED_ITEMS_URL]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        NSDictionary *parameters = @{ @"items": @[ @{ @"itemId": item.itemId } ],
                                      @"accessToken": Constants.ACCESS_TOKEN
                                      };
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json;" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            DebugLog(@"Request %@ Response %@", request, response);
            [overlayView setModeAndProgressWithStateOfTask:task];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            DebugLog(@"%@", resultArray);
            
            for(NSDictionary * itemDictionary in resultArray)
            {
                Item *item = [[Item alloc]init];
                item.itemId = [itemDictionary objectForKey:@"itemId"];
                item.name = [itemDictionary objectForKey:@"itemName"];
                
                [_recommendedItemArray addObject:item];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_itemTableView reloadData];
                [overlayView dismiss:YES];
            });
        }];
        
        [task resume];
    }@catch(NSException *e)
    {
        DebugLog(@"AddRecommendedItemViewController [getRecommendedItem]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
}

- (void) initComponents
{
    self.addButton.layer.cornerRadius = 5;
    self.addButton.layer.borderWidth = 1;
    self.addButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, 100, 40);
    gradient.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient.locations = @[@(0), @(1)];gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    gradient.cornerRadius = 5;
    [[self.addButton layer] addSublayer:gradient];
    
    self.cancelButton.layer.cornerRadius = 5;
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _itemArray = [[NSMutableArray alloc]init];
    _categoryArray = [[NSMutableArray alloc]init];
    _recommendedItemArray = [[NSMutableArray alloc]init];
    
    [self getRecommendedItem:_selectedItem];
    [self getCategory];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _itemTableView)
    {
        return _itemArray.count;
    }
    else
    {
        return _categoryArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _categoryTableView)
    {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        Category *category = _categoryArray[indexPath.row];
        cell.textLabel.text = category.categoryName;
        cell.textLabel.adjustsFontSizeToFitWidth=YES;
        cell.textLabel.minimumScaleFactor=0.5;
        return cell;
    }
    else
    {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        Item *item = _itemArray[indexPath.row];
        cell.textLabel.text = item.name;
        cell.textLabel.adjustsFontSizeToFitWidth=YES;
        cell.textLabel.minimumScaleFactor=0.5;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _categoryTableView)
    {
        UITableViewCell *cell = [_categoryTableView cellForRowAtIndexPath:indexPath];
        Category *category = _categoryArray[indexPath.row];
        cell.textLabel.text = category.categoryName;
        [self getItem:category.categoryId];
    }
    else
    {
        UITableViewCell *cell = [_itemTableView cellForRowAtIndexPath:indexPath];
        Item *item = _itemArray[indexPath.row];
        cell.textLabel.text = item.name;
    }
}

- (IBAction)addButtonClicked:(id)sender
{
    [self addRecommendedItem];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
