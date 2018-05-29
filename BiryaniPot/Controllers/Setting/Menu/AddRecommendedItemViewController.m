//
//  AddRecommendedItemViewController.m
//  BiryaniPot
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
        [self getItem:category.categoryId];
    }
    else
    {
        UITableViewCell *cell = [_itemTableView cellForRowAtIndexPath:indexPath];
        Item *item = _itemArray[indexPath.row];
    }
}

-(void)getCategory
{
    [_categoryArray removeAllObjects];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@??loc_id=%@&filterout=0", Constants.GET_CATEGORIES_URL, Constants.LOCATION_ID]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
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
        
    }];
    [postDataTask resume];
}

-(void)getItem: (NSString *)categoryId
{
    [_itemArray removeAllObjects];
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.GET_ITEMS_BY_CATEGORY_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:@"POST"];
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc]init];
    [paramDict setValue:categoryId forKey:@"catId"];
    [paramDict setValue:@"" forKey:@"searchStr"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:paramDict options:NSJSONWritingPrettyPrinted error:&error];
    
    [request setHTTPBody:data];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *itemsDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        for(NSDictionary *itemDictionary in [itemsDictionary objectForKey:@"items"])
        {
            Item *item = [[Item alloc]init];
            item.itemId = [itemDictionary objectForKey:@"itemId"];
            item.name = [itemDictionary objectForKey:@"itemName"];
            item.price = [itemDictionary objectForKey:@"actuvalPrice"];
            item.discount = [itemDictionary objectForKey:@"discontPrice"];
            item.imageURL = [itemDictionary objectForKey:@"imageUrl"];
            item.detail = [itemDictionary objectForKey:@"description"];
            
            if([itemDictionary objectForKey:@"veg"] == NULL)
            {
                item.isVeg = FALSE;
            }
            else if(([[itemDictionary objectForKey:@"veg"]intValue] == 1))
            {
                item.isVeg = TRUE;
            }
            else item.isVeg = FALSE;
            
            if([itemDictionary objectForKey:@"spiceSuppot"] == NULL)
            {
                item.isSpiceSupported = FALSE;
            }
            else if(([[itemDictionary objectForKey:@"spiceSuppot"]intValue] == 1))
            {
                item.isSpiceSupported = TRUE;
            }
            else item.isSpiceSupported = FALSE;
            
            [_itemArray addObject:item];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_itemTableView reloadData];
            
            if (_itemArray.count > 0)
            {
                NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
                [_itemTableView selectRowAtIndexPath:index animated:true scrollPosition:UITableViewScrollPositionNone];
                [self tableView:_itemTableView didSelectRowAtIndexPath:index];
            }
            
        });
        
    }];
    [postDataTask resume];
}

- (IBAction)addButtonClicked:(id)sender
{
    
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
