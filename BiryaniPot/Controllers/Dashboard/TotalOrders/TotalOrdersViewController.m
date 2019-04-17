//
//  TotalOrdersViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/9/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "TotalOrdersViewController.h"
#import "TotalOrdersTableViewCell.h"
#import "Constants.h"
#import "Feedback.h"
#import "CalendarViewController.h"
#import "Validation.h"

@interface TotalOrdersViewController ()
@property (nonatomic, retain) NSString *searchString;
@property (nonatomic, retain) NSMutableArray *searchResultArray;
@end

@implementation TotalOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.totalOrdersTableView registerNib:[UINib nibWithNibName:@"TotalOrdersTableViewCell" bundle:nil] forCellReuseIdentifier:@"totalOrdersCell"];
    _totalOrderArray = [[NSMutableArray alloc]init];
    _searchResultArray = [[NSMutableArray alloc]init];
    
    [_searchButton setTitle:[NSString stringWithFormat:@"%C", 0xf002] forState:UIControlStateNormal];
    [_searchButton setTitle:[NSString stringWithFormat:@"%C", 0xf002] forState:UIControlStateSelected];
    [_dateFrom setTitle:Constants.GET_DASHBOARD_FROM_DATE forState:UIControlStateNormal];
    [_dateTo setTitle:Constants.GET_DASHBOARD_TO_DATE
             forState:UIControlStateNormal];
    [_dateFrom setTitle:Constants.GET_DASHBOARD_FROM_DATE forState:UIControlStateSelected];
    [_dateTo setTitle:Constants.GET_DASHBOARD_TO_DATE forState:UIControlStateSelected];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self totalOrdersList];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _totalOrderArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TotalOrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"totalOrdersCell"];
    Feedback *totalOrders = _totalOrderArray[indexPath.row];
    cell.delegate = self;
    cell.invoiceButton.tag = indexPath.row;
    [cell setCellData:totalOrders];
    return cell;
}

-(void)totalOrdersList
{
    @try
    {
        MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];

        [_totalOrderArray removeAllObjects];
        
        NSString *fromDate = [Constants changeDateFormatForAPI:_dateFrom.currentTitle];
        NSString *toDate = [Constants changeDateFormatForAPI:_dateTo.currentTitle];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?loc_id=%@&fromdate=%@&todate=%@", Constants.TOTAL_ORDER_LIST_URL, Constants.LOCATION_ID, fromDate, toDate]];
        NSError *error = nil;
        
        DebugLog(@"Request %@", url);
        //[overlayView setModeAndProgressWithStateOfTask:postDataTask];
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
        
        NSArray *totalOrders = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        DebugLog(@"%@", totalOrders);
        
        for(NSDictionary *totalOrder in totalOrders)
        {
            NSString *orderId = [NSString stringWithFormat:@"%@", [totalOrder objectForKey:@"orderId"]];
            NSString *orderType = [totalOrder objectForKey:@"orderType"];
            NSString *paymentType = [totalOrder objectForKey:@"paymentType"];
            NSString *totalAmount = [NSString stringWithFormat:@"$%.2f",[[totalOrder objectForKey:@"totalOrdersAmount"] floatValue]];
            NSString *userEmail = [totalOrder objectForKey:@"userEmail"];
            NSString *userMobile = [totalOrder objectForKey:@"userPhone"];
            
            Feedback *feedback = [[Feedback alloc]init];
            feedback.orderNo = orderId;
            feedback.orderType = orderType;
            feedback.paymentType = paymentType;
            feedback.amount = totalAmount;
            feedback.email = userEmail;
            feedback.contactNumber = userMobile;
           
            [_totalOrderArray addObject:feedback];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_totalOrdersTableView reloadData];
            [overlayView dismiss:YES];
        });
        
    }@catch(NSException *e)
    {
        DebugLog(@"TotalOrdersViewController [totalOrdersList]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
    }
    @finally
    {
        [self totalOrders];
    }
}

-(void)totalOrders
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];

    @try
    {
        NSString *fromDate = [Constants changeDateFormatForAPI:_dateFrom.currentTitle];
        NSString *toDate = [Constants changeDateFormatForAPI:_dateTo.currentTitle];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?loc_id=%@&from_date=%@&to_date=%@", Constants.TOTAL_ORDER_URL, Constants.LOCATION_ID, fromDate, toDate]];
        NSError *error = nil;
        NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
        
        DebugLog(@"Request %@", url);
        //[overlayView setModeAndProgressWithStateOfTask:postDataTask];
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        NSDictionary *totalOrders = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        DebugLog(@"%@",totalOrders);
        
        long orders = [[totalOrders objectForKey:@"totalOrders"] longValue];
        double amount = [[totalOrders objectForKey:@"totalPrice"] doubleValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _totalOrdersLabel.text = [NSString stringWithFormat:@"%ld of $%.2f", orders, amount];
            [overlayView dismiss:YES];
        });
    }@catch(NSException *e)
    {
        DebugLog(@"TotalOrdersViewController [totalOrders]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
    }
    @finally
    {
        [overlayView dismiss:YES];
    }
}

- (IBAction)dateButtonClicked:(id)sender
{
    CalendarViewController * calendarVC = [[CalendarViewController alloc]init];
    calendarVC.modalPresentationStyle = UIModalPresentationFormSheet;
    calendarVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    calendarVC.preferredContentSize = CGSizeMake(400, 450);
    calendarVC.toDateDelegate = _dateTo;
    calendarVC.fromDateDelegate = _dateFrom;
    calendarVC.disableFutureDates = true;
    calendarVC.didDismiss = ^(void){
        [self datesUpdated];
    };
    
    [self presentViewController:calendarVC animated:YES completion:nil];
}

-(void)datesUpdated
{
    @try
    {
        _searchTextField.text = @"";
        [self totalOrdersList];
    }@catch(NSException *e)
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Unable to get Orders"];
        DebugLog(@"%@ %@", e.name, e.reason);
    }
}

- (IBAction)searchButtonClicked:(id)sender
{
    if ([Validation isEmpty:_searchTextField])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Search field must not be empty"];
        return;
    }
    
    [self.view endEditing:YES];
    
    if ( ([[Validation trim:_searchTextField.text] caseInsensitiveCompare:_searchString] == NSOrderedSame) && _searchResultArray.count != 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[_searchResultArray objectAtIndex:0]intValue] inSection:0];
        [_totalOrdersTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        NSNumber *temp = [NSNumber numberWithInt:[[_searchResultArray objectAtIndex:0]intValue]];
        [_searchResultArray removeObjectAtIndex:0];
        [_searchResultArray addObject:temp];
    }
    else
    {
        _searchString = [Validation trim:_searchTextField.text];
        [_searchResultArray removeAllObjects];
        
        for (int i = 0; i<_totalOrderArray.count; i++)
        {
            Feedback *feedback = _totalOrderArray[i];
            
            if([feedback.orderNo isEqualToString:_searchString] || [feedback.contactNumber isEqualToString:_searchString] || (feedback.email && [feedback.email caseInsensitiveCompare:_searchString] == NSOrderedSame))
            {
                [_searchResultArray addObject:[NSNumber numberWithInt:i]];
            }
        }
        
        if (_searchResultArray.count == 0)
        {
            [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"No record found"];
        }
        else
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[_searchResultArray objectAtIndex:0]intValue] inSection:0];
            [_totalOrdersTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            
            NSNumber *temp = [NSNumber numberWithInt:[[_searchResultArray objectAtIndex:0]intValue]];
            [_searchResultArray removeObjectAtIndex:0];
            [_searchResultArray addObject:temp];
        }
    }
}

@end
