//
//  LandingPageCollectionViewCell.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 3/18/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "LandingPageCollectionViewCell.h"

@implementation LandingPageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapped:)];
    _tapGestureRecognizer.numberOfTapsRequired = 1;
    [_image addGestureRecognizer:_tapGestureRecognizer];
    
    _pickerController = [[UIImagePickerController alloc] init];
    _pickerController.delegate = self;
    [_pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)imageTapped:(id)sender
{
    [self.delegate presentViewController:_pickerController animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.delegate dismissViewControllerAnimated:YES completion:nil];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Image Picker Called");
    
    _image.image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self.delegate dismissViewControllerAnimated:YES completion:nil];
}

@end
