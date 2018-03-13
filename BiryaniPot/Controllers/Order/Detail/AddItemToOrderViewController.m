//
//  AddItemToOrderViewController.m
//  BiryaniPot
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
    
    self.confirmButton.layer.cornerRadius = 5;
    self.confirmButton.layer.borderWidth = 1;
    self.confirmButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, 100, 40);
    gradient.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient.locations = @[@(0), @(1)];gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    gradient.cornerRadius = 5;
    [[self.confirmButton layer] addSublayer:gradient];
    
    self.cancelButton.layer.cornerRadius = 5;
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _categoryArray = [[NSMutableArray alloc]init];
    _itemArray = [[NSMutableArray alloc]init];
    
    [self getCategories];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_itemTableView == tableView)return _itemArray.count;
    else return _categoryArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _itemTableView)
    {
        OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
        Item *item = _itemArray[indexPath.row];
        cell.name.text = item.name;
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

-(void)getCategories
{
    NSURL *categoriesURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?loc_id=1&filterout=0",Constants.GET_CATEGORIES_URL]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:categoriesURL];
    NSError *error = nil;
    NSDictionary *categoriesDictionary = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    
    for (NSDictionary *categoryDictionary in categoriesDictionary)
    {
        NSString *categoryId = [categoryDictionary objectForKey:@"categoryId"];
        NSString *categoryName = [categoryDictionary objectForKey:@"categoryName"];
        
        Category *category = [[Category alloc]init];
        category.categoryId = categoryId;
        category.categoryName = categoryName;
        
        [_categoryArray addObject:category];
    }
}

-(void)getItemByCategoryId:(NSString *)categoryId
{
    [_itemArray removeAllObjects];
    
    NSURL *itemsURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?category_id=%@",Constants.GET_ITEMS_BY_CATEGORY_URL, categoryId]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:itemsURL];
    NSError *error = nil;
    NSDictionary *itemsDictionary = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    
    for (NSDictionary *itemDictionary in itemsDictionary)
    {
        NSString *itemName = [itemDictionary objectForKey:@"itemName"];
        
        Item *item = [[Item alloc]init];
        item.name = itemName;
        
        [_itemArray addObject:item];
    }
    [_itemTableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _categoryTableView)
    {
        Category *category =  _categoryArray[indexPath.row];
        [self getItemByCategoryId:category.categoryId];
    }
}

- (IBAction)confirmButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
