//
//  MenuCollectionViewCell.m
// OkidsCafeProvider
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
    
    if (self.isSelected)
    {
        
        self.contentView.backgroundColor = [UIColor colorWithRed:206.0/256.0 green:96.0/256.0 blue:40.0/256.0 alpha:1.0];
        self.label.textColor = [UIColor whiteColor];
    }
    else
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor colorWithRed:206.0/256.0 green:96.0/256.0 blue:40.0/256.0 alpha:1.0];
    }
}

-(void)deleteRecord
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.delegate.view animated:YES];
    
    @try
    {
        NSInteger index = _deleteButton.tag;
        
        Category *category = _delegate.categorySearchArray[index];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?accesstoken=%@&categoryid=%@&locationid=%@&newmenu=0", Constants.DELETE_CATEGORY_URL, Constants.ACCESS_TOKEN, category.categoryId, Constants.LOCATION_ID]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [request setHTTPMethod:@"DELETE"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            DebugLog(@"Request %@ Response %@", request, response);
            [overlayView setModeAndProgressWithStateOfTask:task];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self.delegate withTitle:@"Error" andMessage:@"Unable to Connect"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self.delegate withTitle:@"Error" andMessage:@"Unable to Process"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            DebugLog(@"%@", result);
            
            if ([[result objectForKey:@"success"] intValue] == 1)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self.delegate withTitle:@"Success" andMessage:@"Category Deleted"];
                    [_delegate getCategory];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self.delegate withTitle:@"Error" andMessage:@"Unable to Delete"];
                });
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [overlayView dismiss:YES];
            });
        }];
        
        [task resume];
        
    }@catch(NSException *e)
    {
        DebugLog(@"MenuCollectionViewCell [deleteRecord]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self.delegate withTitle:@"Error" andMessage:@"Unable to Process"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
}

- (IBAction)deleteButtonClicked:(id)sender
{
    if ((_delegate.itemSearchArray.count != 0))
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Validation showSimpleAlertOnViewController:self.delegate withTitle:@"Error" andMessage:@"Can't Delete Non Empty Category"];
        });
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Do you really want to delete?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        return;
    }];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self deleteRecord];

        _delegate.mode = @"VIEW";
        [_delegate modeChanged];
    }];
    
    [alert addAction:yes];
    [alert addAction:no];
    [_delegate presentViewController:alert animated:YES completion:nil];
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    if (self.isSelected)
    {
        self.contentView.backgroundColor = [UIColor colorWithRed:206.0/256.0 green:96.0/256.0 blue:40.0/256.0 alpha:1.0];
        self.label.textColor = [UIColor whiteColor];
    }
    else
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor colorWithRed:206.0/256.0 green:96.0/256.0 blue:40.0/256.0 alpha:1.0];
    }
}

- (IBAction)editButtonClicked:(id)sender
{
    EditCategoryViewController * editCategoryVC = [[EditCategoryViewController alloc]init];
    editCategoryVC.modalPresentationStyle = UIModalPresentationFormSheet;
    editCategoryVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    editCategoryVC.preferredContentSize = CGSizeMake(540, 430);
    editCategoryVC.delegate = _delegate;
    editCategoryVC.category = _delegate.categorySearchArray[_editButton.tag];
    
    [_delegate presentViewController:editCategoryVC animated:YES completion:nil];
}


@end
