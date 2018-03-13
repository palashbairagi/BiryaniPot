//
//  LandingPagesViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/10/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "LandingPagesViewController.h"
#import "Constants.h"

@interface LandingPagesViewController ()

@end

@implementation LandingPagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initComponents];
    [self getImages];
}

-(void)getImages
{
    NSURL *pagesURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?org_id=101",Constants.GET_LANDING_PAGES_URL]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:pagesURL];
    NSError *error = nil;
    NSDictionary *pagesDictionary = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    
    for (NSDictionary *pageDictionary in pagesDictionary)
    {
        NSString *imageURLString = [pageDictionary objectForKey:@"imageUrl"];
        
        [NSThread detachNewThreadSelector:@selector(loadImageByURL:) toTarget:self withObject:imageURLString];
    }
}

-(void)loadImageByURL: (NSString *)imageURLString
{
    NSData *imgData=[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLString]];
    
    UIImage *img=[UIImage imageWithData:imgData];
    
    [self performSelectorOnMainThread:@selector(setImage:) withObject:img waitUntilDone:NO];
}

-(void)setImage: (UIImage *) image
{
    if (_image1.image == NULL)
    {
        _image1.image = image;
    }
    else if (_image2.image == NULL)
    {
        _image2.image = image;
    }
    else if(_image3.image == NULL)
    {
        _image3.image = image;
    }
}

-(void)initComponents
{
    
    _pickerController1 = [[UIImagePickerController alloc] init];
    _pickerController2 = [[UIImagePickerController alloc] init];
    _pickerController3 = [[UIImagePickerController alloc] init];
    
    _pickerController1.delegate = self;
    _pickerController2.delegate = self;
    _pickerController3.delegate = self;
    
}

- (IBAction)image1Tapped:(id)sender
{
    [self presentViewController:_pickerController1 animated:YES completion:nil];
}

- (IBAction)image2Tapped:(id)sender
{
    [self presentViewController:_pickerController2 animated:YES completion:nil];
}

- (IBAction)image3Tapped:(id)sender
{
    [self presentViewController:_pickerController3 animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if (picker == _pickerController1)
    {
        _image1.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    else if(picker == _pickerController2)
    {
        _image2.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    else
    {
        _image3.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
