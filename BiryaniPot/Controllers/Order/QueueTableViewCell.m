//
//  QueueTableViewCell.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/27/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "QueueTableViewCell.h"
#import "CancelViewController.h"
#import "Constants.h"
#import "SelectTimeViewController.h"

@implementation QueueTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)setCellData:(Order *)order
{
    @try
    {
    _orderNo.text = order.orderNo;
    _orderTime.text = order.orderTime;
    [_timeRequired setTitle:order.timeRemain forState:UIControlStateNormal];
    _itemCount.text = order.itemCount;
    _customerName.text = order.customerName;
    }@catch(NSException *e)
    {
        NSLog(@"Exception %@ %@", e.name, e.reason);
    }
}

- (IBAction)startButtonClicked:(UIButton *)sender
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
            [_delegate.queueTableView reloadData];
            [_delegate.preparingTableView reloadData];
        });
    }];
    [postDataTask resume];
    
}

- (IBAction)timeRequiredButtonClicked:(id)sender
{
    SelectTimeViewController * selectTime = [[SelectTimeViewController alloc]init];
    selectTime.modalPresentationStyle = UIModalPresentationFormSheet;
    selectTime.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    selectTime.preferredContentSize = CGSizeMake(300, 270);
    
    selectTime.delegate = self;
    [self.delegate presentViewController:selectTime animated:YES completion:nil];
}

@end
