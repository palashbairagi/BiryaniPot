//
//  SearchTableViewCell.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/12/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellData:(Order *)order
{
    _orderNo.text = order.orderNo;
    _itemCount.text = order.itemCount;
    _customerName.text = order.customerName;
    _contactNumber.text = order.contactNumber;
    _status.text = order.status;
    
    if ([_status.text isEqualToString:@"Queue"])
    {
        [_button setTitle:@"Start" forState:UIControlStateNormal];
        _button.hidden = FALSE;
        _button.backgroundColor = [UIColor colorWithRed:237.0/256.0 green:130.0/256.0 blue:11.0/256.0 alpha:1.0];
    }
//    else if ([_status.text isEqualToString:@"Preparing"])
//    {
//        [_button setTitle:@"Done" forState:UIControlStateNormal];
//        _button.hidden = FALSE;
//        _button.backgroundColor = [UIColor colorWithRed:75.0/256.0 green:160.0/256.0 blue:35.0/256.0 alpha:1.0];
//    }
    else
    {
        _button.hidden = TRUE;
    }
}

- (IBAction)buttonClicked:(id)sender
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
                [_delegate getAllOrders];
                [_delegate.queueTableView reloadData];
                [_delegate.preparingTableView reloadData];
                [_delegate.outForDeliveryTableView reloadData];
                [_delegate.readyToPickupTableView reloadData];
                [_delegate searchTextChanged:_delegate.search];
            });
        }];
        [postDataTask resume];
        
    }@catch(NSException *e)
    {
        DebugLog(@"ProfileViewController [updateProfile]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self.delegate withTitle:@"Error" andMessage:@"Unable to Process"];
    }
    @finally
    {
        [overlayView dismiss:YES];
    }
}

@end
