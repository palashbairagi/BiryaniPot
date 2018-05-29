//
//  MenuCollectionViewCell.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/10/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "MenuCollectionViewCell.h"
#import "Category.h"
#import "EditCategoryViewController.h"

@implementation MenuCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.deleteButton setTitle:[NSString stringWithFormat:@"%C", 0xf014] forState:UIControlStateNormal];
    [self.editButton setTitle:[NSString stringWithFormat:@"%C", 0xf040] forState:UIControlStateNormal];
    
    if (self.selected)
    {
        self.contentView.backgroundColor = [UIColor colorWithRed:206.0/256.0 green:96.0/256.0 blue:40.0/256.0 alpha:0.2];
    }
    else
    {
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    
}

-(void)deleteRecord
{
    NSInteger index = _deleteButton.tag;
    
    Category *category = _delegate.categorySearchArray[index];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", Constants.UPDATE_CATEGORY_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSMutableData *body = [NSMutableData data];
    
    NSDictionary *params = @{
                             @"category_id" : category.categoryId,
                             @"category_name" : category.categoryName,
                             @"is_nonveg_supported" : category.isNonVeg,
                             @"is_active" : @"0"
                             };
    
    NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:contentType forHTTPHeaderField:@"content-Type"];
    
    [params enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    request.HTTPBody = body;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error = %@", error);
            return;
        }
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate getCategory];
        });
    }];
    [task resume];
}

- (IBAction)deleteButtonClicked:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Do you really want to delete?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        return;
    }];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self deleteRecord];
    }];
    
    [alert addAction:yes];
    [alert addAction:no];
    [_delegate presentViewController:alert animated:YES completion:nil];
}

- (IBAction)editButtonClicked:(id)sender
{
    EditCategoryViewController * editCategoryVC = [[EditCategoryViewController alloc]init];
    editCategoryVC.modalPresentationStyle = UIModalPresentationFormSheet;
    editCategoryVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    editCategoryVC.preferredContentSize = CGSizeMake(540, 500);
    editCategoryVC.delegate = _delegate;
    editCategoryVC.category = _delegate.categorySearchArray[_editButton.tag];
    
    [_delegate presentViewController:editCategoryVC animated:YES completion:nil];
}


@end
