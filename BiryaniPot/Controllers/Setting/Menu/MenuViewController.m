//
//  MenuViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/10/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCollectionViewCell.h"
#import "RecommendedItemsCollectionViewCell.h"
#import "AddCategoryViewController.h"
#import "Category.h"
#import "Item.h"
#import "AddRecommendedItemViewController.h"

@interface MenuViewController ()
@property int itemTypeIndex;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initComponents];
}

-(void)getCategory
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        [_categoryArray removeAllObjects];
        [_categorySearchArray removeAllObjects];
        
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
                [_categorySearchArray addObject:category];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_menuCollectionView reloadData];
                [overlayView dismiss:YES];
            });
            
        }];
        
        [postDataTask resume];
        
    }@catch(NSException *e)
    {
        DebugLog(@"MenuViewController [getCategory]: %@ %@",e.name, e.reason);
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
        [_itemSearchArray removeAllObjects];
        
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
                
                [_itemArray addObject:item];
                [_itemSearchArray addObject:item];
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
        DebugLog(@"MenuViewController [getItem]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
    }
    @finally
    {
        [overlayView dismiss:YES];
    }
}

-(void)addItem
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        NSString *itemName = [NSString stringWithFormat:@"%@", _name.text];
        NSString *price = [NSString stringWithFormat:@"%@", _price.text];
        NSString *discount = [NSString stringWithFormat:@"%@", _discount.text];
        NSString *itemDetail = [NSString stringWithFormat:@"%@", _detail.text];
        NSString *loyaltyPoints = [NSString stringWithFormat:@"%@", _loyaltyPoints.text];
        
        NSString *veg;
        if (_veg == FALSE)veg =@"0";
        else veg = @"1";
        
        NSString *spice;
        if (_spice == FALSE)spice =@"0";
        else spice = @"1";
        
        NSString *typeId = [NSString stringWithFormat:@"%d", _itemTypeIndex+1];
        
        NSArray *selectedIndex = [_menuCollectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = selectedIndex[0];
        Category *category = _categoryArray[indexPath.row];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.INSERT_ITEM_URL]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        NSMutableData *body = [NSMutableData data];
        
        NSDictionary *params = @{
                                     @"accesstoken" :   Constants.ACCESS_TOKEN,
                                     @"name" : itemName,
                                     @"description" : itemDetail,
                                     @"categoryid" : category.categoryId,
                                     @"itemtypeid" : typeId,
                                     @"amount" : price,
                                     @"discount" : discount,
                                     @"isveg" : veg,
                                     @"pointsrequired"  : loyaltyPoints,
                                     @"isspicesupported" : spice,
                                     @"locationid" : Constants.LOCATION_ID,
                                     @"newmenu" : @"0"
                                 };
        DebugLog(@"%@", params);
        
        NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831466499882746641449"];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        
        [request setHTTPMethod:@"PUT"];
        [request setValue:contentType forHTTPHeaderField:@"content-Type"];
        
        [params enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
        }];
        
        NSData *imageData = UIImageJPEGRepresentation(_image.image, 1.0);
        NSString *fieldName = @"image";
        NSString *mimetype  = [NSString stringWithFormat:@"image/jpg"];
        NSString *imgName = [NSString stringWithFormat:@"%@.jpg",itemName];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, imgName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        request.HTTPBody = body;
        
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
            
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            DebugLog(@"%@", result);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([result isEqualToString:@"Item created"])
                {
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Item Created"];
                    [self getItem:category.categoryId];
                }
                else
                {
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Unable to Create Item"];
                }
                
                [overlayView dismiss:YES];
            });
            
        }];
        
        [task resume];
        
    }@catch(NSException *e)
    {
        DebugLog(@"MenuViewController [addItem]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
}

-(void)updateItem
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        NSString *itemName = [NSString stringWithFormat:@"%@", _name.text];
        NSString *price = [NSString stringWithFormat:@"%@", _price.text];
        NSString *discount = [NSString stringWithFormat:@"%@", _discount.text];
        NSString *itemDetail = [NSString stringWithFormat:@"%@", _detail.text];
        NSString *loyaltyPoints = [NSString stringWithFormat:@"%@", _loyaltyPoints.text];
        
        NSString *veg;
        if (_veg == FALSE)veg =@"0";
        else veg = @"1";
        
        NSString *spice;
        if (_spice == FALSE)spice =@"0";
        else spice = @"1";
        
        NSString *typeId = [NSString stringWithFormat:@"%d", _itemTypeIndex+1];
        
        NSArray *selectedIndex = [_menuCollectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = selectedIndex[0];
        Category *category = _categoryArray[indexPath.row];
        
        indexPath = [_itemTableView indexPathForSelectedRow];
        Item *item = _itemSearchArray[indexPath.row];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.UPDATE_ITEM_URL]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        NSMutableData *body = [NSMutableData data];
        
        NSDictionary *params = @{
                                 @"accesstoken" :   Constants.ACCESS_TOKEN,
                                 @"itemid" : item.itemId,
                                 @"name" : itemName,
                                 @"description" : itemDetail,
                                 @"categoryid" : category.categoryId,
                                 @"itemtypeid" : typeId,
                                 @"amount" : price,
                                 @"discount" : discount,
                                 @"isveg" : veg,
                                 @"pointsrequired"  : loyaltyPoints,
                                 @"isspicesupported" : spice,
                                 @"locationid" : Constants.LOCATION_ID,
                                 @"newmenu" : @"0"
                                 };
        DebugLog(@"%@", params);
        
        NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831466499882746641449"];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:contentType forHTTPHeaderField:@"content-Type"];
        
        [params enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
        }];
        
        NSData *imageData = UIImageJPEGRepresentation(_image.image, 1.0);
        NSString *fieldName = @"image";
        NSString *mimetype  = [NSString stringWithFormat:@"image/jpg"];
        NSString *imgName = [NSString stringWithFormat:@"%@.jpg",itemName];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, imgName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        request.HTTPBody = body;
        
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
            
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            DebugLog(@"%@", result);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([result isEqualToString:@"Item updated"])
                {
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Item Updated"];
                    [self getItem:category.categoryId];
                }
                else
                {
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Unable to Create Item"];
                }
                
                [overlayView dismiss:YES];
            });
            
        }];
        
        [task resume];
        
    }@catch(NSException *e)
    {
        DebugLog(@"MenuViewController [updateItem]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
}

-(void)deleteItem
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        NSArray *selectedIndex = [_menuCollectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = selectedIndex[0];
        Category *category = _categoryArray[indexPath.row];
        
        indexPath = [_itemTableView indexPathForSelectedRow];
        Item *item = _itemSearchArray[indexPath.row];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?accesstoken=%@&itemid=%@&locationid=%@&newmenu=0", Constants.DELETE_ITEM_URL, Constants.ACCESS_TOKEN, item.itemId, Constants.LOCATION_ID]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [request setHTTPMethod:@"DELETE"];
        
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
            
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            DebugLog(@"%@", result);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[result objectForKey:@"success"] intValue] == 1)
                {
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Success" andMessage:@"Item Deleted"];
                    [self getItem:category.categoryId];
                    _mode = @"VIEW";
                    [self modeChanged];
                }
                else
                {
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Delete Item"];
                }
                
                [overlayView dismiss:YES];
            });
        }];
        
        [task resume];
        
    }@catch(NSException *e)
    {
        DebugLog(@"MenuViewController [deleteItem]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
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
                [_recommendedItemCollectionView reloadData];
                [overlayView dismiss:YES];
            });
        }];
        
        [task resume];
    }@catch(NSException *e)
    {
        DebugLog(@"MenuViewController [getRecommendedItem]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
}

-(void) deleteRecommendedItem: (Item *) recItem
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
        
        NSString *postString = [NSString stringWithFormat:@"item_id=%@&rec_item_id=%@&loc_id=%@&statement_type=delete", item.itemId, recItem.itemId, Constants.LOCATION_ID];
        
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
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Successful" andMessage:@"Recommended Item Deleted"];
                    [self getRecommendedItem:item];
                }
                else
                {
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Delete"];
                }
                
                [overlayView dismiss:YES];
            });
        }];
        
        [task resume];
    }@catch(NSException *e)
    {
        DebugLog(@"MenuViewController [deleteRecommendedItem]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
}

-(void)initComponents
{
    self.addCategoryButton.layer.cornerRadius = 5;
    self.addCategoryButton.layer.borderWidth = 1;
    self.addCategoryButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient1 = [CAGradientLayer layer];
    gradient1.frame = CGRectMake(0, 0, 100, 40);
    gradient1.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient1.locations = @[@(0), @(1)];gradient1.startPoint = CGPointMake(0.5, 0);
    gradient1.endPoint = CGPointMake(0.5, 1);
    gradient1.cornerRadius = 5;
    [[self.addCategoryButton layer] addSublayer:gradient1];
    
    self.saveButton.layer.cornerRadius = 5;
    self.saveButton.layer.borderWidth = 1;
    self.saveButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient2 = [CAGradientLayer layer];
    gradient2.frame = CGRectMake(0, 0, 100, 35);
    gradient2.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient2.locations = @[@(0), @(1)];gradient2.startPoint = CGPointMake(0.5, 0);
    gradient2.endPoint = CGPointMake(0.5, 1);
    gradient2.cornerRadius = 5;
    [[self.saveButton layer] addSublayer:gradient2];
    
    self.saveButton.layer.cornerRadius = 5;
    self.saveButton.layer.borderWidth = 1;
    self.saveButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient3 = [CAGradientLayer layer];
    gradient3.frame = CGRectMake(0, 0, 100, 35);
    gradient3.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient3.locations = @[@(0), @(1)];gradient3.startPoint = CGPointMake(0.5, 0);
    gradient3.endPoint = CGPointMake(0.5, 1);
    gradient3.cornerRadius = 5;
    [[self.cancelButton layer]addSublayer:gradient3];
    
    self.type.layer.masksToBounds = YES;
    self.type.backgroundDimmingOpacity = 0.0;
    
    [self.recommendedItemCollectionView registerNib:[UINib nibWithNibName:@"RecommendedItemsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"recommendedItemsCell"];
    [self.menuCollectionView registerNib:[UINib nibWithNibName:@"MenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"categoryCell"];
    [self.deleteItemButton setTitle:[NSString stringWithFormat:@"%C", 0xf014] forState:UIControlStateNormal];
    
    _itemArray = [[NSMutableArray alloc]init];
    _categoryArray = [[NSMutableArray alloc]init];
    _recommendedItemArray = [[NSMutableArray alloc]init];
    _categorySearchArray = [[NSMutableArray alloc]init];
    _itemSearchArray = [[NSMutableArray alloc]init];
    _typeArray = [NSArray arrayWithObjects:@"Breakfast", @"Lunch", @"Dessert/Snacks", @"Dinner", nil ];
    
    _categoryQueue = [[NSOperationQueue alloc] init];
    
//    for (int i = 0; i<10; i++) {
//        if (i%2 ==0)[_recommendedItemArray addObject:[NSString stringWithFormat:@"Item %d", i]];
//        else [_recommendedItemArray addObject:[NSString stringWithFormat:@"RecommendedItem %d", i]];
//    }

    _veg = TRUE;
    _spice = TRUE;
    
    [_isVegButton setTitle:[NSString stringWithFormat:@"%C", 0xf00c] forState:UIControlStateNormal];
    [_spiceSupportButton setTitle:[NSString stringWithFormat:@"%C", 0xf00c] forState:UIControlStateNormal];
   
    [self getCategory];
    
    _mode = @"VIEW";
    
    _itemDescriptionView.hidden = TRUE;
    _itemTableView.hidden = TRUE;
    _saveButton.hidden = TRUE;
    _cancelButton.hidden = TRUE;
    _itemSearchView.hidden = TRUE;
    
    [self modeChanged];
}

-(void) modeChanged
{
    if([_mode isEqualToString:@"EDIT"])
    {
        [_itemDescriptionView setUserInteractionEnabled:TRUE];
        
        [_saveButton setEnabled:YES];
        [_cancelButton setEnabled:YES];
        
        self.saveButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
        [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.cancelButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
        [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _recommendedItemView.hidden = FALSE;
    }
    else if([_mode isEqualToString:@"ADD"])
    {
        NSIndexPath *indexPath = [_itemTableView indexPathForSelectedRow];
        NSArray *indexes = [_menuCollectionView indexPathsForSelectedItems];
        
        if (indexes.count > 0)
        {
            [self tableView:_itemTableView didDeselectRowAtIndexPath:indexPath];
        }
        else
        {
            [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Please select a category"];
            return;
        }
        
        [_saveButton setEnabled:YES];
        [_cancelButton setEnabled:YES];
        
        self.saveButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
        [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.cancelButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
        [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_itemDescriptionView setUserInteractionEnabled:TRUE];
        
        _name.text = @"";
        _price.text = @"";
        _discount.text = @"";
        _detail.text = @"";
        _loyaltyPoints.text = @"";
        _isVegButton.backgroundColor = [UIColor whiteColor];
        _veg = FALSE;
        _spiceSupportButton.backgroundColor = [UIColor whiteColor];
        _spice = FALSE;
        _image.image = [UIImage imageNamed:@"biryanipot"];
        [_type selectRow:0 inComponent:0];
        
        _recommendedItemView.hidden = TRUE;
    }
    else //mode = VIEW
    {
        [_itemSearchArray removeAllObjects];
        [_itemTableView reloadData];
        
        [_itemDescriptionView setUserInteractionEnabled:FALSE];
        _recommendedItemView.hidden = FALSE;
        
        [_saveButton setEnabled:NO];
        [_cancelButton setEnabled:NO];
        
        self.saveButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
        [self.saveButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        self.cancelButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
        [self.cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        _name.text = @"";
        _price.text = @"";
        _discount.text = @"";
        _detail.text = @"";
        _loyaltyPoints.text = @"";
        _isVegButton.backgroundColor = [UIColor whiteColor];
        _veg = FALSE;
        _spiceSupportButton.backgroundColor = [UIColor whiteColor];
        _spice = FALSE;
        _image.image = [UIImage imageNamed:@"biryanipot"];
        
        _recommendedItemView.hidden = TRUE;
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (collectionView == _recommendedItemCollectionView)
    {
        RecommendedItemsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recommendedItemsCell" forIndexPath:indexPath];
        
        if(indexPath.row < _recommendedItemArray.count)
        {
            Item *item = _recommendedItemArray[indexPath.row];
            cell.label.text = item.name;
        }
        else
        {
            cell.label.text = @"Add";
        }
        
        return cell;
    }
    else
    {
        MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"categoryCell" forIndexPath:indexPath];
        
        cell.delegate = self;
        cell.deleteButton.tag = indexPath.row;
        cell.editButton.tag = indexPath.row;
        
        Category *category = _categorySearchArray[indexPath.row];
        
        if (category.image == nil )
        {
                NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{

                NSData * imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:category.imageURL]];
                    
                UIImage * image;
                
                if ([UIImage imageWithData:imgData])
                {
                    image = [UIImage imageWithData:imgData];
                }
                else
                {
                    image = [UIImage imageNamed:@"biryanipot"];
                }
                
                category.image = image;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.menuCollectionView reloadItemsAtIndexPaths:@[indexPath]];
                });

            }];

            [_categoryQueue addOperation:op];
        }
        else
        {
            cell.image.image = category.image;
        }
        
        cell.label.text = category.categoryName;
        
        if (cell.isSelected)
        {
            cell.contentView.backgroundColor = [UIColor colorWithRed:206.0/256.0 green:96.0/256.0 blue:40.0/256.0 alpha:1.0];
            cell.label.textColor = [UIColor whiteColor];
        }
        else
        {
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.label.textColor = [UIColor colorWithRed:206.0/256.0 green:96.0/256.0 blue:40.0/256.0 alpha:1.0];
        }
        
        return cell;
    }
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _menuCollectionView)
    {
        return _categorySearchArray.count;
    }
    else
    {
        return _recommendedItemArray.count+1;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _menuCollectionView)
    {
        MenuCollectionViewCell *cell = (MenuCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor colorWithRed:206.0/256.0 green:96.0/256.0 blue:40.0/256.0 alpha:1.0];
        cell.label.textColor = [UIColor whiteColor];
        
        _mode = @"ADD";
        [self modeChanged];
        
        Category *category = _categorySearchArray[indexPath.row];
        [self getItem:category.categoryId];
        
        _itemDescriptionView.hidden = FALSE;
        _itemTableView.hidden = FALSE;
        _saveButton.hidden = FALSE;
        _cancelButton.hidden = FALSE;
        _itemSearchView.hidden = FALSE;
        
        _itemSearchTextField.text = @"";
    }
    else
    {
        if(indexPath.row < _recommendedItemArray.count)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"Confirmation" message:@"Do you want to delete selected recommended item?" preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle: @"Confirm" style: UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    Item *item = _recommendedItemArray[indexPath.row];
                    [self deleteRecommendedItem:item];
                });
                
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: @"Cancel" style: UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
                
            }];
            
            [alertController addAction: okAction];
            [alertController addAction: cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else
        {
            NSIndexPath *selectedIndex = _itemTableView.indexPathForSelectedRow;
            
            AddRecommendedItemViewController *ari = [[AddRecommendedItemViewController alloc]init];
            ari.modalPresentationStyle = UIModalPresentationFormSheet;
            ari.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            ari.preferredContentSize = CGSizeMake(720, 438);
            ari.selectedItem = _itemArray[selectedIndex.row];
            ari.delegate = self; 
            
            [self presentViewController:ari animated:YES completion:nil];
        }
    }
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _menuCollectionView)
    {
        MenuCollectionViewCell *cell = (MenuCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.label.textColor = [UIColor colorWithRed:206.0/256.0 green:96.0/256.0 blue:40.0/256.0 alpha:1.0];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _menuCollectionView)
    {
        return CGSizeMake(CGRectGetHeight(collectionView.frame), (CGRectGetHeight(collectionView.frame)));
    }
    else
    {
        if (indexPath.row < _recommendedItemArray.count)
        {
            Item *item = [_recommendedItemArray objectAtIndex:indexPath.row];
            CGSize size = [item.name sizeWithAttributes:NULL];
            return CGSizeMake(size.width+70, CGRectGetHeight(collectionView.frame));
        }
        else
        {
            CGSize size = [@"Add" sizeWithAttributes:NULL];
            return CGSizeMake(size.width+70, CGRectGetHeight(collectionView.frame));
        }
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemSearchArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    Item *item = _itemSearchArray[indexPath.row];
    cell.textLabel.text = item.name;
    cell.textLabel.adjustsFontSizeToFitWidth=YES;
    cell.textLabel.minimumScaleFactor=0.5;
    
    if (cell.isSelected)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:206.0/256.0 green:96.0/256.0 blue:40.0/256.0 alpha:1.0];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _itemDescriptionView.hidden = FALSE;
    _saveButton.hidden = FALSE;
    _cancelButton.hidden = FALSE;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    Item *item = _itemSearchArray[indexPath.row];
    
    if (item.name == NULL)item.name = @"";
    else _name.text = item.name;
        
    if (item.price == NULL)item.price = @"";
    else _price.text = item.price;
        
    if (item.discount == NULL)item.discount = @"";
    else _discount.text = item.discount;
        
    if (item.detail == NULL)item.itemId = @"";
    else _detail.text = item.detail;
    
    if (item.pointsRequired == NULL)item.pointsRequired = @"";
    else _loyaltyPoints.text = item.pointsRequired;
    
    if (item.isSpiceSupported)
    {
        _spiceSupportButton.backgroundColor = [UIColor colorWithRed:0.0 green:109.0/256 blue:1.0 alpha:1.0];
        _spice = TRUE;
    }
    else
    {
        _spiceSupportButton.backgroundColor = [UIColor whiteColor];
        _spice = FALSE;
    }
    
    if (item.isVeg)
    {
        _isVegButton.backgroundColor = [UIColor colorWithRed:0.0 green:109.0/256 blue:1.0 alpha:1.0];
        _veg = TRUE;
    }
    else
    {
        _isVegButton.backgroundColor = [UIColor whiteColor];
        _veg = FALSE;
    }
    
    int index = [item.itemTypeId intValue];
    self.typeLabel.text = _typeArray[index-1];
        
    if (item.image == nil )
    {
        NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
            
            NSData * imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.imageURL]];
            UIImage * image;
            
            if ([UIImage imageWithData:imgData])
            {
                image = [UIImage imageWithData:imgData];
            }
            else
            {
                image = [UIImage imageNamed:@"biryanipot"];
            }
            
            item.image = image;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_image setImage:image];
            });
            
        }];
        
        [_categoryQueue addOperation:op];
    }
    else
    {
        _image.image = item.image;
    }
    
    [self getRecommendedItem:item];
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:206.0/256.0 green:96.0/256.0 blue:40.0/256.0 alpha:1.0];
    cell.textLabel.textColor = [UIColor whiteColor];
 
    _mode = @"EDIT";
    [self modeChanged];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (cell.isSelected)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:206.0/256.0 green:96.0/256.0 blue:40.0/256.0 alpha:1.0];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor blackColor];
    }
}

-(NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu
{
    return 1;
}

-(NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component
{
    return _typeArray.count;
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[NSAttributedString alloc] initWithString:_typeArray[row] attributes:@{ NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _itemTypeIndex = row;
    NSString *selectedOption = self.typeArray[row];
    self.typeLabel.text = selectedOption;
    
    [dropdownMenu closeAllComponentsAnimated:YES];
}

- (IBAction)uploadPhotoTapped:(id)sender
{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate=self;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _image.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    PHAsset *phAsset = [[PHAsset fetchAssetsWithALAssetURLs:@[imageURL] options:nil] lastObject];
    NSString *imageName = [phAsset valueForKey:@"filename"];
    
    _extension = [imageName pathExtension];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addCategoryButtonClicked:(id)sender {
    AddCategoryViewController * addCategoryVC = [[AddCategoryViewController alloc]init];
    addCategoryVC.modalPresentationStyle = UIModalPresentationFormSheet;
    addCategoryVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    addCategoryVC.preferredContentSize = CGSizeMake(540, 500);
    addCategoryVC.delegate = self;
    
    [self presentViewController:addCategoryVC animated:YES completion:nil];
}


- (IBAction)isVegButtonClicked:(id)sender
{
    if(_veg)
    {
        _isVegButton.backgroundColor = [UIColor whiteColor];
        _veg = FALSE;
    }
    else
    {
        _isVegButton.backgroundColor = [UIColor colorWithRed:0.0 green:109.0/256 blue:1.0 alpha:1.0];
        _veg = TRUE;
    }
}

- (IBAction)spiceSupportButtonClicked:(id)sender
{
    if(_spice)
    {
        _spiceSupportButton.backgroundColor = [UIColor whiteColor];
        _spice = FALSE;
    }
    else
    {
        _spiceSupportButton.backgroundColor = [UIColor colorWithRed:0.0 green:109.0/256 blue:1.0 alpha:1.0];
        _spice = TRUE;
    }
}

- (IBAction)addButtonClicked:(id)sender
{
    NSArray *indexes = [_menuCollectionView indexPathsForSelectedItems];
    
    if (indexes.count > 0)
    {
        _mode = @"ADD";
        [self modeChanged];
    }
    else
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Please select a category"];
    }
}

- (IBAction)saveButtonClicked:(id)sender
{
    if (![self isValidate]) return;
    
    if ([_mode isEqualToString:@"ADD"])
    {
        [self addItem];
    }
    else
    {
        [self updateItem];
    }
}

- (IBAction)cancelButtonClicked:(id)sender
{
    NSIndexPath *indexPath = [_itemTableView indexPathForSelectedRow];
    
    if (indexPath.row > 0)
    {
        _mode = @"EDIT";
        [self modeChanged];
        
        [_itemTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    else
    {
        _mode = @"ADD";
        [self modeChanged];
    }
}

- (IBAction)deleteButtonClicked:(id)sender
{
    [self alert];
}

- (IBAction)categorySearchStringChanged:(id)sender
{
    _itemDescriptionView.hidden = TRUE;
    _itemTableView.hidden = TRUE;
    _saveButton.hidden = TRUE;
    _cancelButton.hidden = TRUE;
    _itemSearchView.hidden = TRUE;
    
    [_categorySearchArray removeAllObjects];
    NSString *searchString = [Validation trim:_categorySearchTextField.text];
    
    if([searchString length] == 0)
    {
        if ([_categorySearchTextField.text isEqualToString:@" "])
        {
            _categorySearchTextField.text = @"";
        }
        
        [self getCategory];
    }
    else
    {
        for(Category *category in _categoryArray)
        {
            if(category.categoryName && [category.categoryName rangeOfString:searchString options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [_categorySearchArray addObject:category];
            }
        }
    }
    
    [_menuCollectionView reloadData];
}

- (IBAction)itemSearchStringChanged:(id)sender
{
    _itemDescriptionView.hidden = TRUE;
    _saveButton.hidden = TRUE;
    _cancelButton.hidden = TRUE;
    
    [_itemSearchArray removeAllObjects];
    NSString *searchString = [Validation trim:_itemSearchTextField.text];
    
    if([searchString length] == 0)
    {
        if ([_itemSearchTextField.text isEqualToString:@" "])
        {
            _itemSearchTextField.text = @"";
        }
        
        NSArray <NSIndexPath *> *indexPathArray = _menuCollectionView.indexPathsForSelectedItems;
        NSIndexPath *indexPath = indexPathArray[0];
        
        Category *cat = _categoryArray[0];
        
        if (indexPath.row > 0)
            cat = _categoryArray[indexPath.row];
        
        [self getItem:cat.categoryId];
    }
    else
    {
        for(Item *item in _itemArray)
        {
            if(item.name && [item.name rangeOfString:searchString options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [_itemSearchArray addObject:item];
            }
        }
    }
    
    [_itemTableView reloadData];
}

- (void) alert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirm" message:@"Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        return;
    }];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self deleteItem];
        });
        
    }];
    
    [alert addAction:yes];
    [alert addAction:no];
    [self presentViewController:alert animated:YES completion:nil];

}

-(BOOL)isValidate
{
    if ([Validation isEmpty:_name])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Name Field should not be empty"];
        return false;
    }
    if ([Validation isMore:_name thanMaxLength:30])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Name Field should not be more than 30 characters"];
        return false;
    }
    
    if ([Validation isEmpty:_price])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Price Field should not be empty"];
        return false;
    }
    if ([Validation isMore:_price thanMaxLength:5])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Price Field should not be more than 4 digits"];
        return false;
    }
    if ([Validation isDecimal:_price])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Price Field should contain numeric value"];
        return false;
    }
    
    if ([Validation isEmpty:_discount])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Discount Field should not be empty"];
        return false;
    }
    if ([Validation isMore:_discount thanMaxLength:5])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Discount Field should not be more than 4 digits"];
        return false;
    }
    if ([Validation isDecimal:_discount])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Discount Field should contain numeric value"];
        return false;
    }
    
    if ([[Validation trim:_detail.text] length] == 0)
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Description Field should not be empty"];
        return false;
    }
    if ([[Validation trim:_detail.text] length] > 250)
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Description Field should not be more than 250 characters"];
        return false;
    }
    
    if ([_typeLabel.text isEqualToString:@"Select"])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Please Select Type"];
        return false;
    }
    
    
    if ([Validation isEmpty:_loyaltyPoints])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Loyalty Points Field should not be empty"];
        return false;
    }
    if ([Validation isMore:_loyaltyPoints thanMaxLength:3])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Loyalty Points Field should not be more than 3 digits"];
        return false;
    }
    if ([Validation isNumber:_loyaltyPoints])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Loyalty Points Field should contain numeric value"];
        return false;
    }
    
    return true;
}

@end
