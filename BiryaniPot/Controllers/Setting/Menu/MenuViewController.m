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

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initComponents];
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
    
    [self.recommendedItemCollectionView registerNib:[UINib nibWithNibName:@"RecommendedItemsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"recommendedItemsCell"];
    [self.menuCollectionView registerNib:[UINib nibWithNibName:@"MenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"categoryCell"];
    [self.deleteItemButton setTitle:[NSString stringWithFormat:@"%C", 0xf014] forState:UIControlStateNormal];
    
    _itemArray = [[NSMutableArray alloc]init];
    _categoryArray = [[NSMutableArray alloc]init];
    _recommendedItemArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<10; i++) {
        
        if (i%2 ==0)
        {
            [_recommendedItemArray addObject:[NSString stringWithFormat:@"Item %d", i]];
        }
        else
        [_recommendedItemArray addObject:[NSString stringWithFormat:@"RecommendedItem %d", i]];
    }
    _categoryQueue = [[NSOperationQueue alloc] init];
    
    [self getCategory];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (collectionView == _recommendedItemCollectionView)
    {
        RecommendedItemsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recommendedItemsCell" forIndexPath:indexPath];
        cell.label.text = _recommendedItemArray[indexPath.row];
        return cell;
    }
    else
    {
        MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"categoryCell" forIndexPath:indexPath];
        
        Category *category = _categoryArray[indexPath.row];
        
        if (category.image == nil )
        {
                NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{

                NSData * imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:category.imageURL]];
                    
                if (imgData == NULL)
                {
                    UIImage * image = [UIImage imageNamed:@"biryanipotusa"];
                    category.image = image;
                }
                else
                {
                    UIImage * image = [UIImage imageWithData:imgData];
                    category.image = image;
                }
                    
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
        
        if (cell.selected)
        {
            cell.contentView.backgroundColor = [UIColor colorWithRed:206.0/256.0 green:96.0/256.0 blue:40.0/256.0 alpha:0.2];
        }
        else
        {
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        
        return cell;
    }
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _menuCollectionView)
    {
        return _categoryArray.count;
    }
    else
    {
        return _recommendedItemArray.count;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _menuCollectionView)
    {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor colorWithRed:206.0/256.0 green:96.0/256.0 blue:40.0/256.0 alpha:0.2];
        Category *category = _categoryArray[indexPath.row];
        [self getItem:category.categoryId];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _menuCollectionView)
    {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor clearColor];
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
        NSString *itemString = [_recommendedItemArray objectAtIndex:indexPath.row];
        CGSize size = [itemString sizeWithAttributes:NULL];
        return CGSizeMake(size.width+70, CGRectGetHeight(collectionView.frame));
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    Item *item = _itemArray[indexPath.row];
    cell.textLabel.text = item.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item *item = _itemArray[indexPath.row];
    _name.text = item.name;
//    _price.text = item.price;
//    _discount.text = item.discount;
    _detail.text = item.detail;
    
    if (item.image == nil )
    {
        NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
            
            NSData * imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.imageURL]];
            UIImage * image = [UIImage imageWithData:imgData];
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
}

- (IBAction)addCategoryButtonClicked:(id)sender {
    AddCategoryViewController * addCategoryVC = [[AddCategoryViewController alloc]init];
    addCategoryVC.modalPresentationStyle = UIModalPresentationFormSheet;
    addCategoryVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    addCategoryVC.preferredContentSize = CGSizeMake(540, 500);
    
    [self presentViewController:addCategoryVC animated:YES completion:nil];
}


-(void)getCategory
{
    [_categoryArray removeAllObjects];
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.GET_CATEGORY_ON_SETTING_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:@"POST"];
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc]init];
    [paramDict setValue:@"1" forKey:@"locId"];
    [paramDict setValue:@"" forKey:@"searchStr"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:paramDict options:NSJSONWritingPrettyPrinted error:&error];
    
    [request setHTTPBody:data];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *categoriesDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        for(NSDictionary *categoryDictionary in [categoriesDictionary objectForKey:@"categories"])
        {
            Category *category = [[Category alloc]init];
            category.categoryName = [categoryDictionary objectForKey:@"catName"];
            category.categoryId = [categoryDictionary objectForKey:@"catId"];
            category.imageURL = [categoryDictionary objectForKey:@"imageUrl"];
            category.menuId = [categoryDictionary objectForKey:@"menuId"];
            
            [_categoryArray addObject:category];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_menuCollectionView reloadData];
            
            if (_categoryArray.count > 0)
            {
                NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
                [_menuCollectionView selectItemAtIndexPath:index animated:true scrollPosition:UICollectionViewScrollPositionNone];
                [self collectionView:_menuCollectionView didSelectItemAtIndexPath:index];
            }
        });
        
    }];
    [postDataTask resume];
}

-(void)getItem: (NSString *)categoryId
{
    [_itemArray removeAllObjects];
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.GET_ITEM_ON_SETTING_URL]];
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
            item.discount = [itemDictionary objectForKey:@"discount"];
            item.imageURL = [itemDictionary objectForKey:@"imageUrl"];
            item.detail = [itemDictionary objectForKey:@"description"];
            
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

@end
