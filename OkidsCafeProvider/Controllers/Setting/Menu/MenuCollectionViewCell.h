//
//  MenuCollectionViewCell.h
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 1/10/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface MenuCollectionViewCell : UICollectionViewCell <NSURLSessionDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (nonatomic, retain) MenuViewController *delegate;

@end 
