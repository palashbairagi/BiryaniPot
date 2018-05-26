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
    
    [self.recommendedItemCollectionView registerNib:[UINib nibWithNibName:@"RecommendedItemsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"recommendedItemsCell"];
    [self.menuCollectionView registerNib:[UINib nibWithNibName:@"MenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"categoryCell"];
    [self.deleteItemButton setTitle:[NSString stringWithFormat:@"%C", 0xf014] forState:UIControlStateNormal];
    
    _itemArray = [[NSMutableArray alloc]init];
    _categoryArray = [[NSMutableArray alloc]init];
    _recommendedItemArray = [[NSMutableArray alloc]init];
    _categorySearchArray = [[NSMutableArray alloc]init];
    _itemSearchArray = [[NSMutableArray alloc]init];
    _categoryQueue = [[NSOperationQueue alloc] init];
    
    for (int i = 0; i<10; i++) {
        if (i%2 ==0)[_recommendedItemArray addObject:[NSString stringWithFormat:@"Item %d", i]];
        else [_recommendedItemArray addObject:[NSString stringWithFormat:@"RecommendedItem %d", i]];
    }
    [_recommendedItemArray addObject:@"Add"];
    
    _veg = TRUE;
    _spice = TRUE;
    
    [_isVegButton setTitle:[NSString stringWithFormat:@"%C", 0xf00c] forState:UIControlStateNormal];
    [_spiceSupportButton setTitle:[NSString stringWithFormat:@"%C", 0xf00c] forState:UIControlStateNormal];
    [self disableAllButtons];
    
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
        
        cell.delegate = self;
        cell.deleteButton.tag = indexPath.row;
        
        Category *category = _categorySearchArray[indexPath.row];
        
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
        return _categorySearchArray.count;
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
        Category *category = _categorySearchArray[indexPath.row];
        [self getItem:category.categoryId];
    }
    else
    {
        if(indexPath.row != _recommendedItemArray.count-1)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"Confirmation" message:@"Do you want to delete selected recommended item?" preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle: @"Confirm" style: UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_recommendedItemArray removeObjectAtIndex:indexPath.row];
                    [_recommendedItemCollectionView reloadData];
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
            AddRecommendedItemViewController *ari = [[AddRecommendedItemViewController alloc]init];
            ari.modalPresentationStyle = UIModalPresentationFormSheet;
            ari.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            ari.preferredContentSize = CGSizeMake(720, 438);
            ari.delegate = self; 
            
            [self presentViewController:ari animated:YES completion:nil];
        }
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
        NSString *itemString;
        itemString = [_recommendedItemArray objectAtIndex:indexPath.row];
        CGSize size = [itemString sizeWithAttributes:NULL];
        return CGSizeMake(size.width+70, CGRectGetHeight(collectionView.frame));
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
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item *item = _itemSearchArray[indexPath.row];
    
    if (item.name == NULL)item.name = @"";
    else _name.text = item.name;
        
    if (item.price == NULL)item.price = @"";
    //else _price.text = item.price;
        
    if (item.discount == NULL)item.discount = @"";
    else _discount.text = item.discount;
        
    if (item.detail == NULL)item.itemId = @"";
    else _detail.text = item.detail;
    
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
    addCategoryVC.delegate = self;
    
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
    [paramDict setValue:Constants.LOCATION_ID forKey:@"locId"];
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
            [_categorySearchArray addObject:category];
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
            
        });
        
    }];
    [postDataTask resume];
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
    _name.text = @"";
    _price.text = @"";
    _discount.text = @"";
    _isVegButton.backgroundColor = [UIColor whiteColor];
    _veg = FALSE;
    _spiceSupportButton.backgroundColor = [UIColor whiteColor];
    _spice = FALSE;
    _detail.text = @"Description";
    _image.image = [UIImage imageNamed:@"biryanipotusa"];
    [self enableAllButtons];
}

-(void) disableAllButtons
{
    [_saveButton setEnabled:NO];
    [_cancelButton setEnabled:NO];
    
    self.saveButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    [self.saveButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    self.cancelButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    [self.cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

-(void) enableAllButtons
{
    [_saveButton setEnabled:YES];
    [_cancelButton setEnabled:YES];
    
    self.saveButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.cancelButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)addItem
{
    NSString *imgURL = @"xyz.jpeg";
    NSString *itemName = _name.text;
    NSString *itemDetail = _detail.text;
    NSString *price = _price.text;
    NSString *discount = _discount.text;
    
    if(discount == nil)discount = 0;
    
    NSArray *selectedItem = [_menuCollectionView indexPathsForSelectedItems];
    Category *category = _categoryArray[0];
    
    NSString *veg;
    if (_veg == FALSE)veg =@"0";
    else veg = @"1";
    
    NSString *spice;
    if (_spice == FALSE)spice =@"0";
    else spice = @"1";
    
    NSString *post = [NSString stringWithFormat:@"item_name=%@&item_img_url=%@&item_description=%@&category_id=%@&item_type_id=2&amount=%@&discount=%@&is_veg=%@&is_spice_supported=%@&is_active=1&loc_id=%@&rec_items=0", itemName, imgURL, itemDetail, category.categoryId, price, discount, veg, spice, Constants.LOCATION_ID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.INSERT_ITEM_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        dispatch_async(dispatch_get_main_queue(), ^{

        });

    }];
    [postDataTask resume];
}

-(void)updateItem
{
    NSIndexPath *indexPath = [_itemTableView indexPathForSelectedRow];
    Item * item = _itemArray[indexPath.row];
    
    NSString *imgURL = @"xyz.jpeg";
    NSString *itemName = _name.text;
    NSString *itemDetail = _detail.text;
    NSString *price = _price.text;
    NSString *discount = _discount.text;
    
    if(discount == nil)discount = 0;
    
    NSArray *selectedItem = [_menuCollectionView indexPathsForSelectedItems];
    Category *category = _categoryArray[0];
    
    NSString *veg;
    if (_veg == FALSE)veg =@"0";
    else veg = @"1";
    
    NSString *spice;
    if (_spice == FALSE)spice =@"0";
    else spice = @"1";
    
    NSString *post = [NSString stringWithFormat:@"item_id=%@&item_name=%@&item_img_url=%@&item_description=%@&category_id=%@&item_type_id=2&amount=%@&discount=%@&is_veg=%@&is_spice_supported=%@&is_active=1", item.itemId, itemName, imgURL, itemDetail, category.categoryId, price, discount, veg, spice];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.UPDATE_ITEM_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    }];
    [postDataTask resume];
}

-(void)deleteItem
{
    NSIndexPath *indexPath = [_itemTableView indexPathForSelectedRow];
    Item * item = _itemArray[indexPath.row];
    
    NSString *imgURL = @"xyz.jpeg";
    NSString *itemName = _name.text;
    NSString *itemDetail = _detail.text;
    NSString *price = _price.text;
    NSString *discount = _discount.text;
    
    if(discount == nil)discount = 0;
    
    NSArray *selectedItem = [_menuCollectionView indexPathsForSelectedItems];
    Category *category = _categoryArray[0];
    
    NSString *veg;
    if (item.isVeg == FALSE)veg =@"0";
    else veg = @"1";
    
    NSString *spice;
    if (item.isSpiceSupported == FALSE)spice =@"0";
    else spice = @"1";
    
    NSString *post = [NSString stringWithFormat:@"item_id=%@&item_name=%@&item_img_url=%@&item_description=%@&category_id=%@&item_type_id=2&amount=%@&discount=%@&is_veg=%@&is_spice_supported=%@&is_active=0", item.itemId, item.name, item.imageURL, item.detail, category.categoryId, item.price, item.discount, veg, spice];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.UPDATE_ITEM_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    }];
    [postDataTask resume];
}

- (IBAction)saveButtonClicked:(id)sender
{
    [self updateItem];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    
}

- (IBAction)deleteButtonClicked:(id)sender
{
    [self deleteItem];
}

- (IBAction)categorySearchStringChanged:(id)sender
{
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
    [_itemSearchArray removeAllObjects];
    NSString *searchString = [Validation trim:_itemSearchTextField.text];
    
    if([searchString length] == 0)
    {
        if ([_itemSearchTextField.text isEqualToString:@" "])
        {
            _itemSearchTextField.text = @"";
        }
        
        Category *cat = _categoryArray[0];
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

@end
