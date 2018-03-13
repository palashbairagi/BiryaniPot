//
//  OfferCollectionViewCell.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/21/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "OfferCollectionViewCell.h"
#import "EditOfferViewController.h"

@implementation OfferCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_editButton setTitle:[NSString stringWithFormat:@"%C", 0xf040] forState:UIControlStateNormal];
    [_editButton setTitle:[NSString stringWithFormat:@"%C", 0xf040] forState:UIControlStateHighlighted];
    [_deleteButton setTitle:[NSString stringWithFormat:@"%C", 0xf014] forState:UIControlStateNormal];
    [_deleteButton setTitle:[NSString stringWithFormat:@"%C", 0xf014] forState:UIControlStateHighlighted];
}

- (IBAction)editButtonClicked:(UIButton *)sender
{
    EditOfferViewController * editOfferViewController = [[EditOfferViewController alloc]init];
    editOfferViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    editOfferViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    editOfferViewController.preferredContentSize = CGSizeMake(540, 680);
    
    [self.delegate presentViewController:editOfferViewController animated:YES completion:nil];

}

- (IBAction)deleteButtonClicked:(UIButton *)sender
{
    for (NSIndexPath *indexPath in self.delegate.offerCollectionView.indexPathsForSelectedItems)
    {
        [self.delegate.offerCollectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
    
    [self.delegate.offerArray removeObjectAtIndex:sender.tag];
    [self.delegate.offerCollectionView reloadData];
}


@end
