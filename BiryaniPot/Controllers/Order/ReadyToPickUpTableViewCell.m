//
//  ReadyToPickUpTableViewCell.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/27/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "ReadyToPickUpTableViewCell.h"

@implementation ReadyToPickUpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.checkIconButton setTitle:[NSString stringWithFormat:@"%C", 0xf058] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithRed:1 green:0.98 blue:0.67 alpha:1]];
    [self setSelectedBackgroundView:bgColorView];
}

-(void)setCellData:(Order *)order
{
    _orderNo.text = order.orderNo;
    _itemCount.text = [NSString stringWithFormat:@"%@ Items", order.itemCount];
    _customerName.text = order.customerName;
}

- (IBAction)checkIconButtonClicked:(UIButton *)sender
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.delegate.view animated:YES];
    
    @try
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?order_id=%@", Constants.UPDATE_ORDER_STATUS_URL,_orderNo.text]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            DebugLog(@"Request %@ Response %@", request, response);
            [overlayView setModeAndProgressWithStateOfTask:postDataTask];
            
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Validation showSimpleAlertOnViewController:self.delegate withTitle:@"Error" andMessage:@"Unable to Connect"];
                    [overlayView dismiss:YES];
                });
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate loadData];
            });
            
        }];
        
        [postDataTask resume];
        
    }@catch(NSException *e)
    {
        DebugLog(@"ReadyToPickUpTableViewCell [checkIconButtonClicked]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self.delegate withTitle:@"Error" andMessage:@"Unable to Process"];
    }
    @finally
    {
        [overlayView dismiss:YES];
    }
}

@end
