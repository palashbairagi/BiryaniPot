//
//  MenuCollectionViewCell.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/10/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "MenuCollectionViewCell.h"
#import "Category.h"

@implementation MenuCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.deleteButton setTitle:[NSString stringWithFormat:@"%C", 0xf014] forState:UIControlStateNormal];
    
    if (self.selected)
    {
        self.contentView.backgroundColor = [UIColor colorWithRed:206.0/256.0 green:96.0/256.0 blue:40.0/256.0 alpha:0.2];
    }
    else
    {
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    
}

- (IBAction)deleteButtonClicked:(id)sender
{
    NSInteger index = _deleteButton.tag;
    
    Category *category = _delegate.categoryArray[index];
    
    NSString *post = [NSString stringWithFormat:@"category_id=%@&category_name=%@&img_url=%@&is_active=0", category.categoryId, category.categoryName, category.imageURL];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.DELETE_CATEGORY_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate.categoryArray removeAllObjects];
            [_delegate getCategory];
            [_delegate.menuCollectionView reloadData];
        });

    }];
    [postDataTask resume];
    
}

@end
