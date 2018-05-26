//
//  PreparingTableViewCell.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/27/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "PreparingTableViewCell.h"
#import "SelectDeliveryPersonViewController.h"
#import "Constants.h"

@implementation PreparingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setCellData:(Order *)order
{
    _orderNo.text = order.orderNo;
    _orderTime.text = order.orderTime;
    _timeRemain.text = order.timeRemain;
    _itemCount.text = [NSString stringWithFormat:@"%@ Items", order.itemCount];
    _customerName.text = order.customerName;
}

- (IBAction)doneButtonClicked:(UIButton *)sender {
    
    Order *order = _delegate.preparingArray[sender.tag];
    
    if ([order.deliveryType isEqualToString:@"1"])
    {
        SelectDeliveryPersonViewController *sdp = [[SelectDeliveryPersonViewController alloc]init];
        sdp.modalPresentationStyle = UIModalPresentationFormSheet;
        sdp.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        sdp.preferredContentSize = CGSizeMake(300, 260);
        
        Order *order = _delegate.preparingArray[sender.tag];
        sdp.order = order;
        sdp.delegate = _delegate;
        
        [_delegate presentViewController:sdp animated:YES completion:nil];
    }
    else
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?order_id=%@", Constants.UPDATE_ORDER_STATUS_URL,_orderNo.text]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate getAllOrders];
                [_delegate.preparingTableView reloadData];
                [_delegate.readyToPickupTableView reloadData];
            });
        }];
        [postDataTask resume];
    }
    
    
}


@end
