//
//  OfferViewController.m
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 12/22/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "OfferViewController.h"
#import "AddOfferViewController.h"
#import "OfferCollectionViewCell.h"
#import "Offer.h"
#import "Constants.h"

@interface OfferViewController ()

@end

@implementation OfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initComponents];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self getOffers];
}

-(void)initComponents
{
    self.addNewOfferButton.layer.cornerRadius = 5;
    self.addNewOfferButton.layer.borderWidth = 1;
    self.addNewOfferButton.layer.borderColor = [[UIColor colorWithRed:0.84 green:0.13 blue:0.15 alpha:1] CGColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, 140, 40);
    gradient.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor colorWithRed:0.82 green:0.35 blue:0.11 alpha:1] CGColor]];
    gradient.locations = @[@(0), @(1)];gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    gradient.cornerRadius = 5;
    [[self.addNewOfferButton layer] addSublayer:gradient];
    
    [_offerCollectionView registerNib:[UINib nibWithNibName:@"OfferCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"offerCell"];
    
    self.offerArray = [[NSMutableArray alloc]init];
    _offerQueue = [[NSOperationQueue alloc] init];
}

- (IBAction)newOfferButtonClicked:(id)sender
{
    AddOfferViewController * addOfferViewController = [[AddOfferViewController alloc]init];
    addOfferViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    addOfferViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    addOfferViewController.preferredContentSize = CGSizeMake(1000 , 566);
    addOfferViewController.delegate = self;
    
    [self presentViewController:addOfferViewController animated:YES completion:nil];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _offerArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OfferCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"offerCell" forIndexPath:indexPath];
    
    Offer *offer = _offerArray[indexPath.row];
    
    if (offer.image == nil )
    {
        NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
            
            UIImage * image = [UIImage imageNamed:@"biryanipotusa"];
            NSData * imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:offer.imageURL]];
            
            if (imgData != NULL)
            {
                image = [UIImage imageWithData:imgData];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.offerImage setImage:image];
               // [_offerCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            });
            
        }];
        
        [_offerQueue addOperation:op];
    }
    else
    {
        cell.offerImage.image = offer.image;
    }
    
    cell.promoCode.text = offer.name;
    cell.offerDescription.text = offer.detail;
    cell.startsFrom.text = [self changeDateFormat: offer.startFrom];
    cell.expiresOn.text = [self changeDateFormat: offer.endAt];
    cell.editButton.tag = indexPath.row;
    cell.deleteButton.tag = indexPath.row;
    cell.delegate = self;
    
    if (cell.selected)
    {
        [cell.disableView setHidden:NO];
    }
    else
    {
        [cell.disableView setHidden:YES];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    OfferCollectionViewCell *cell = (OfferCollectionViewCell *)[_offerCollectionView cellForItemAtIndexPath:indexPath];
    
    if ([cell.disableView isHidden])
    {
        [cell.disableView setHidden:NO];
    }
    else
    {
        [cell.disableView setHidden:YES];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    OfferCollectionViewCell *cell = (OfferCollectionViewCell *)[_offerCollectionView cellForItemAtIndexPath:indexPath];
    [cell.disableView setHidden:YES];
}

-(void)getOffers
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        [_offerArray removeAllObjects];
    
        NSURL *offerURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?loc_id=%@",Constants.GET_OFFERS_URL, Constants.LOCATION_ID]];
        NSError *error = nil;
        NSData *responseJSONData = [NSData dataWithContentsOfURL:offerURL];
        
        DebugLog(@"Request %@", offerURL);
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        NSDictionary *offersDictionary = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        DebugLog(@"%@", offersDictionary);
        
        for (NSDictionary *offerDictionary in offersDictionary)
        {
            Offer *offer = [[Offer alloc]init];
            offer.offerId = [offerDictionary objectForKey:@"codeId"];
            offer.name = [offerDictionary objectForKey:@"codeName"];
            offer.offerValue = [offerDictionary objectForKey:@"couponPercent"];
            offer.imageURL = [offerDictionary objectForKey:@"couponImgURL"];
            offer.startFrom = [offerDictionary objectForKey:@"validFrom"];
            offer.endAt = [offerDictionary objectForKey:@"validTill"];
            offer.detail = [offerDictionary objectForKey:@"codeDescription"];
            offer.maxDisc = [offerDictionary objectForKey:@"maxDisc"];
            offer.maxTimes = [offerDictionary objectForKey:@"maxTimes"];
            offer.minValue = [offerDictionary objectForKey:@"minValue"];
            offer.maxUsageLimit = [offerDictionary objectForKey:@"couponUsageLimit"];
            offer.isPercent = [offerDictionary objectForKey:@"isPercentage"];
            
            [_offerArray addObject:offer];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [overlayView dismiss:YES];
        });
        
    }@catch(NSException *e)
    {
        DebugLog(@"OfferViewController [getOffers]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
        [overlayView dismiss:YES];
    }
    @finally
    {
        
    }
}

-(NSString *)changeDateFormat: (NSString *) currentDate
{
    NSString *convertedDate = @"";
    @try
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:currentDate];
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
        [dateFormatter1 setDateFormat:@"MMM dd"];
        
        convertedDate = [dateFormatter1 stringFromDate:date];
    }
    @catch(NSException *e)
    {
        DebugLog(@"%@ %@", e.name, e.reason);
    }
    return convertedDate;
}

@end
