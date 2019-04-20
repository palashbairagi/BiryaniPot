//
//  LandingPagesViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/10/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "LandingPagesViewController.h"
#import "LandingPageCollectionViewCell.h"
#import "LandingImage.h"
#import "Constants.h"

@interface LandingPagesViewController ()

@end

@implementation LandingPagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initComponents];
}

-(void)getImages
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        [_landingImageArray removeAllObjects];
        NSURL *pagesURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?org_id=%@",Constants.GET_LANDING_PAGES_URL, Constants.ORGANIZATION_ID]];
        NSError *error = nil;
        NSData *responseJSONData = [NSData dataWithContentsOfURL:pagesURL];
        NSDictionary *pagesDictionary = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
        
        DebugLog(@"Request %@", pagesURL);
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        DebugLog(@"%@", pagesDictionary);
        
        for (NSDictionary *pageDictionary in pagesDictionary)
        {
            NSString *imageURLString = [pageDictionary objectForKey:@"imageUrl"];
            LandingImage *landingImage = [[LandingImage alloc]init];
            landingImage.imageURL = imageURLString;
            [_landingImageArray addObject:landingImage];
        }
        
        [overlayView dismiss:YES];
        
    }@catch(NSException *e)
    {
        DebugLog(@"LandingPagesViewController [getImages]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
    }
    @finally
    {
        [overlayView dismiss:YES];
    }
}

-(void)initComponents
{
    _imageQueue = [[NSOperationQueue alloc]init];
    _landingImageArray = [[NSMutableArray alloc]init];
    
    [self getImages];
    
    [self.landingPageCollectionView registerNib:[UINib nibWithNibName:@"LandingPageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"landingImageCell"];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LandingPageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"landingImageCell" forIndexPath:indexPath];
    cell.delegate = self;
    LandingImage * landingImage = [_landingImageArray objectAtIndex:indexPath.row];
    
    if (landingImage.image == nil )
    {
        NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
            
            NSData * imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:landingImage.imageURL]];
            
            if (imgData == NULL)
            {
                UIImage * image = [UIImage imageNamed:@"biryanipotusa"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    landingImage.image = image;
                    cell.image.tag = indexPath.row;
                });
            }
            else
            {
                UIImage * image = [UIImage imageWithData:imgData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    landingImage.image = image;
                    cell.image.tag = indexPath.row;
                });
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.landingPageCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            });
            
        }];
        
        [_imageQueue addOperation:op];
    }
    else
    {
        cell.image.image = landingImage.image;
        cell.image.tag = indexPath.row;
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _landingImageArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(((CGRectGetWidth(collectionView.frame)/3)-7), CGRectGetHeight(collectionView.frame));
}

@end
