//
//  TopSellerViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/8/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "TopSellerViewController.h"
#import "Constants.h"
#import "CalendarViewController.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

@interface TopSellerViewController ()
@property (nonatomic, retain) NSMutableArray *searchXArray;
@property (nonatomic, retain) NSMutableArray *searchYArray;
@end

@implementation TopSellerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchXArray = [[NSMutableArray alloc]init];
    _searchYArray = [[NSMutableArray alloc]init];
    
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
    _xAxisArray =  [[NSMutableArray alloc]init];
    _yAxisArray = [[NSMutableArray alloc]init];
    
    [self topSellers];
    
}

-(void) drawGraph
{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(30,30,_topSellersView.frame.size.width-60, _topSellersView.frame.size.height-60)];
    _scrollView.showsVerticalScrollIndicator=YES;
    _scrollView.scrollEnabled=YES;
    _scrollView.alwaysBounceVertical = FALSE;
    _scrollView.alwaysBounceHorizontal = FALSE;
    _scrollView.userInteractionEnabled=YES;
   
    _graph = [[SCRSidewaysBarGraph alloc] initWithFrame:CGRectMake(0, 0,_scrollView.bounds.size.width, _yAxisArray.count*21)];
    
    _graph.barFillColor = RGB(206, 96, 40);
    _graph.barBackgroundColor = RGB(255,255,255);
    _graph.labelTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:12.0f]};
    _graph.countTextAttributes = _graph.labelTextAttributes;
    _graph.showCount = YES;
    
    _scrollView.contentSize = CGSizeMake(_graph.frame.size.width, _graph.frame.size.height);
    
    [self.topSellersView addSubview:_scrollView];
}

-(void)topSellers
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];

    @try
    {
        [_scrollView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [_yAxisArray removeAllObjects];
        [_xAxisArray removeAllObjects];
        
        NSString *fromDate = [Constants changeDateFormatForAPI:_dateFrom.currentTitle];
        NSString *toDate = [Constants changeDateFormatForAPI:_dateTo.currentTitle];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?loc_id=%@&from_date=%@&to_date=%@", Constants.TOP_SELLERS_URL, Constants.LOCATION_ID, fromDate, toDate]];
        NSError *error = nil;
        NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
        
        DebugLog(@"Request %@", url);
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                [overlayView dismiss:YES];;
            });
            return;
        }
        
        NSDictionary *topSellersDic = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        DebugLog(@"%@", topSellersDic);
        
        NSArray *topSellersArray = [topSellersDic objectForKey:@"topSellers"];
        
        for(NSDictionary *topSeller in topSellersArray)
        {
            NSString *itemName = [topSeller objectForKey:@"itemName"];
            NSNumber *total = [NSNumber numberWithInt:[[topSeller objectForKey:@"timesSold"] intValue]];
      
            [_yAxisArray addObject:itemName];
            [_xAxisArray addObject:total];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
                if (_yAxisArray.count != 0)
                {
                    [self drawGraph];
                    [_graph setXValues:_xAxisArray];
                    [_graph setYAxisLabels:_yAxisArray];
                    [_graph setMaxXValue: [_xAxisArray[0] intValue]];
                    [_graph reloadInputViews];
                    [self.scrollView addSubview:_graph];
                }
                else
                {
                    [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"No Data"];
                }
            
            [overlayView dismiss:YES];
        });
    }
    @catch(NSException *e)
    {
        DebugLog(@"TopSellerViewController [topSellers]: %@ %@",e.name, e.reason);
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
        [self topSellers];
    }@catch(NSException *e)
    {
        DebugLog(@"TopSellerViewController [datesUpdated]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
    }
}

- (IBAction)searchButtonClicked:(id)sender
{
    if([[Validation trim:_searchTextField.text]length] == 0)
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"Empty Search Field"];
        return;
    }
    
    [_searchYArray removeAllObjects];
    [_searchXArray removeAllObjects];
    
    NSString *searchString = [Validation trim:_searchTextField.text];
    
    for(int i = 0; i<_yAxisArray.count; i++)
    {
        NSString *stringFromArray = [_yAxisArray objectAtIndex:i];
        
        if([stringFromArray rangeOfString:searchString options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [_searchXArray addObject:_xAxisArray[i]];
            [_searchYArray addObject:_yAxisArray[i]];
        }
    }
    
    [_scrollView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    if(_searchYArray.count != 0)
    {
        [self drawGraph];
        [_graph setXValues:_searchXArray];
        [_graph setYAxisLabels:_searchYArray];
        [_graph setMaxXValue: [_searchXArray[0] intValue]];
        [_graph reloadInputViews];
        [self.scrollView addSubview:_graph];
    }
    else
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"No Data"];
    }
}

- (IBAction)searchTextFieldEditingChanged:(id)sender
{
    if([[Validation trim:_searchTextField.text]length] == 0)
    {
        if([_searchTextField.text isEqualToString:@" "])
        {
            _searchTextField.text = @"";
            return;
        }
        
        [_scrollView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        
        if(_yAxisArray.count != 0)
        {
            [self drawGraph];
            [_graph setXValues:_xAxisArray];
            [_graph setYAxisLabels:_yAxisArray];
            [_graph setMaxXValue: [_xAxisArray[0] intValue]];
            [_graph reloadInputViews];
            [self.scrollView addSubview:_graph];
        }
        else
        {
            [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"No Data"];
        }
    }
}


@end
