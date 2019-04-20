//
//  FeedbackViewController.m
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 1/8/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedbackTableViewCell.h"
#import "Feedback.h"
#import "Constants.h"
#import "FeedbackDetailViewController.h"
#import "CalendarViewController.h"

@interface FeedbackViewController ()
    @property (nonatomic, retain) NSString *searchString;
    @property (nonatomic, retain) NSMutableArray *searchResultArray;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchResultArray = [[NSMutableArray alloc]init];
    [_dateFrom setTitle:Constants.GET_DASHBOARD_FROM_DATE forState:UIControlStateNormal];
    [_dateTo setTitle:Constants.GET_DASHBOARD_TO_DATE
             forState:UIControlStateNormal];
    [_dateFrom setTitle:Constants.GET_DASHBOARD_FROM_DATE forState:UIControlStateSelected];
    [_dateTo setTitle:Constants.GET_DASHBOARD_TO_DATE forState:UIControlStateSelected];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self initComponents];
    [self feedbackTags];
    [self feedback];
    [self totalOrdersList];
}

-(void)initComponents
{
    [_searchButton setTitle:[NSString stringWithFormat:@"%C", 0xf002] forState:UIControlStateNormal];
    [_searchButton setTitle:[NSString stringWithFormat:@"%C", 0xf002] forState:UIControlStateSelected];
    
    _happySmiley.text = [NSString stringWithFormat:@"%C", 0xf118];
    _sadSmiley.text = [NSString stringWithFormat:@"%C", 0xf119];
    
    [self.feedbackTableView registerNib:[UINib nibWithNibName:@"FeedbackTableViewCell" bundle:nil] forCellReuseIdentifier:@"feedbackCell"];
    _feedbackArray = [[NSMutableArray alloc]init];
    
    _positiveDictionary = [[NSMutableDictionary alloc]init];
    _negativeDictionary = [[NSMutableDictionary alloc]init];
}

- (void)createPieChart{
    _positiveChart = [[PieChart alloc] initWithFrame:CGRectMake(100, 10, self.positiveFeedbackView.bounds.size.width-80, self.positiveFeedbackView.bounds.size.height-20)];
    [_positiveChart setDataSource:self];
    
    [_positiveChart setShowLegend:TRUE];
    [_positiveChart setLegendViewType:LegendTypeHorizontal];
    
    [_positiveChart setTextFontSize:12];
    [_positiveChart setTextColor:[UIColor blackColor]];
    [_positiveChart setTextFont:[UIFont systemFontOfSize:_positiveChart.textFontSize]];
    
    [_positiveChart setShowValueOnPieSlice:TRUE];
    [_positiveChart setShowCustomMarkerView:TRUE];
    
    [_positiveChart drawPieChart:_positiveChart];
    [self.positiveFeedbackView addSubview:_positiveChart];
    
    _negativeChart = [[PieChart alloc] initWithFrame:CGRectMake(100, 10, self.negativeFeedbackView.bounds.size.width-80, self.negativeFeedbackView.bounds.size.height-20)];
    [_negativeChart setDataSource:self];
    
    [_negativeChart setShowLegend:TRUE];
    [_negativeChart setLegendViewType:LegendTypeHorizontal];
    
    [_negativeChart setTextFontSize:12];
    [_negativeChart setTextColor:[UIColor blackColor]];
    [_negativeChart setTextFont:[UIFont systemFontOfSize:_negativeChart.textFontSize]];
    
    [_negativeChart setShowValueOnPieSlice:TRUE];
    [_negativeChart setShowCustomMarkerView:TRUE];
    
    [_negativeChart drawPieChart:_negativeChart];
    [self.negativeFeedbackView addSubview:_negativeChart];
}

- (NSInteger)numberOfValuesForPieChart{
    return 4;
}

- (UIColor *)colorForValueInPieChartWithIndex:(NSInteger)lineNumber{
    switch (lineNumber) {
        case 0:
            return [UIColor colorWithRed:237.0/256.0 green:120/256.0 blue:11.0/256.0 alpha:1];
            break;
            
        case 1:
            return [UIColor colorWithRed:0.0/256.0 green:0.0/256.0 blue:256.0/256.0 alpha:1];
            break;
            
        case 2:
            return [UIColor colorWithRed:0.0/256.0 green:230.0/256.0 blue:0.0/256.0 alpha:1];
            break;
            
        case 3:
            return [UIColor colorWithRed:256.0/256.0 green:0.0/256.0 blue:0.0/256.0 alpha:1];
            break;
            
    }
    return [UIColor whiteColor];
}

- (NSString *)titleForValueInPieChartWithIndex:(NSInteger)index{
    
    switch (index) {
        case 0:
            return [NSString stringWithFormat:@"Ontime Delivery"];
            break;
            
        case 1:
            return [NSString stringWithFormat:@"Taste"];
            break;
        
        case 2:
            return [NSString stringWithFormat:@"Food Quantity"];
            break;
        
        case 3:
            return [NSString stringWithFormat:@"Food Quality"];
            break;
        
    }
    return [NSString stringWithFormat:@""];
}

- (NSNumber *)valueInPieChartWithIndex:(NSInteger)index inPieChart:(PieChart *) pieChart{
    
    if (pieChart == _positiveChart)
    {
        switch (index) {
            case 0:
                return _positiveDelivery;
                break;
                
            case 1:
                return _positiveTaste;
                break;
                
            case 2:
                return _positiveQuantity;
                break;
                
            case 3:
                return _positiveQuality;
                break;
        }
    }
    else
    {
        switch (index) {
            case 0:
                return _negativeDelivery;
                break;
                
            case 1:
                return _negativeTaste;
                break;
                
            case 2:
                return _negativeQuantity;
                break;
                
            case 3:
                return _negativeQuality;
                break;
        }
    }
    return [NSNumber numberWithLong:0];
}

- (UIView *)customViewForPieChartTouchWithValue:(NSNumber *)value{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view.layer setCornerRadius:4.0F];
    [view.layer setBorderWidth:1.0F];
    [view.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [view.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [view.layer setShadowRadius:2.0F];
    [view.layer setShadowOpacity:0.3F];
    
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:[NSString stringWithFormat:@"%@", value]];
    [label setFrame:CGRectMake(0, 0, 100, 30)];
    [view addSubview:label];
    
    [view setFrame:label.frame];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _feedbackArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedbackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedbackCell"];
    Feedback *feedback = _feedbackArray[indexPath.row];
    [cell setCellData:feedback];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Feedback *feedback = _feedbackArray[indexPath.row];
    
    if (feedback.smiley == nil || [feedback.smiley isEqualToString:@""])
    {
        [Validation showSimpleAlertOnViewController:self withTitle:@"Alert" andMessage:@"No Ratings"];
        return;
    }
    
    FeedbackDetailViewController *feedbackDetailVC = [[FeedbackDetailViewController alloc]init];
    feedbackDetailVC.modalPresentationStyle = UIModalPresentationFormSheet;
    feedbackDetailVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    feedbackDetailVC.preferredContentSize = CGSizeMake(800, 500);
    feedbackDetailVC.delegate = _feedbackArray[indexPath.row];
    
    [self presentViewController:feedbackDetailVC animated:YES completion:nil];
}

-(void)totalOrdersList
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        [_feedbackArray removeAllObjects];
    
        NSString *fromDate = [Constants changeDateFormatForAPI:_dateFrom.currentTitle];
        NSString *toDate = [Constants changeDateFormatForAPI:_dateTo.currentTitle];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?loc_id=%@&fromdate=%@&todate=%@", Constants.TOTAL_ORDER_LIST_URL, Constants.LOCATION_ID, fromDate, toDate]];
        NSError *error = nil;
        NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
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
            NSString *smiley = [totalOrder objectForKey:@"feedbackType"];
            NSString *orderId = [NSString stringWithFormat:@"%@", [totalOrder objectForKey:@"orderId"]];
            NSString *orderType = [totalOrder objectForKey:@"orderType"];
            NSString *paymentType = [totalOrder objectForKey:@"paymentType"];
            NSString *totalAmount = [NSString stringWithFormat:@"%@", [totalOrder objectForKey:@"totalOrdersAmount"]];
            NSString *userEmail = [totalOrder objectForKey:@"userEmail"];
            NSString *userMobile = [totalOrder objectForKey:@"userPhone"];
            NSString *orderDate = [self convertDate:[totalOrder objectForKey:@"orderDate"]];
            
            Feedback *feedback = [[Feedback alloc]init];
            feedback.smiley = smiley;
            feedback.orderNo = orderId;
            feedback.orderType = orderType;
            feedback.paymentType = paymentType;
            feedback.amount = totalAmount;
            feedback.email = userEmail;
            feedback.contactNumber = userMobile;
            feedback.orderDate = orderDate;
            
            [_feedbackArray addObject:feedback];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_feedbackTableView reloadData];
            [overlayView dismiss:YES];
        });
    }
    @catch(NSException *e)
    {
        DebugLog(@"FeedbackViewController [totalOrdersList]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
    }
    @finally
    {
        [overlayView dismiss:YES];
    }
}

-(void)feedbackTags
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        _positiveTaste = 0;
        _positiveQuality = 0;
        _positiveQuantity = 0;
        _positiveDelivery = 0;
        
        _negativeTaste = 0;
        _negativeQuality = 0;
        _negativeQuantity = 0;
        _negativeTaste = 0;
        
        NSString *fromDate = [Constants changeDateFormatForAPI:_dateFrom.currentTitle];
        NSString *toDate = [Constants changeDateFormatForAPI:_dateTo.currentTitle];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?loc_id=%@&fromdate=%@&todate=%@", Constants.FEEDBACK_TAG_URL, Constants.LOCATION_ID, fromDate, toDate]];
        
        NSError *error = nil;
        NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
        
        DebugLog(@"Request %@", url);
    
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        NSArray *feedbackTags = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        DebugLog(@"%@", feedbackTags);
        
        for(NSDictionary *feedbackTag in feedbackTags)
        {
            NSString *tagName = [feedbackTag objectForKey:@"tagName"];
            NSString *tagType = [feedbackTag objectForKey:@"tagType"];
            NSNumber *tagCount = [NSNumber numberWithFloat:[[feedbackTag objectForKey:@"tagCount"] floatValue]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([tagType isEqualToString:@"Good"])
                {
                    if ([tagName isEqualToString:@"Food Quality"])
                    {
                        _positiveQuality = tagCount;
                    }
                    else if ([tagName isEqualToString:@"Food Quantity"])
                    {
                        _positiveQuantity = tagCount;
                    }
                    else if ([tagName isEqualToString:@"Taste"])
                    {
                        _positiveTaste = tagCount;
                    }
                    else
                    {
                        _positiveDelivery = tagCount;
                    }
                }
                else
                {
                    if ([tagName isEqualToString:@"Food Quality"])
                    {
                        _negativeQuality = tagCount;
                    }
                    else if ([tagName isEqualToString:@"Food Quantity"])
                    {
                        _negativeQuantity = tagCount;
                    }
                    else if ([tagName isEqualToString:@"Taste"])
                    {
                        _negativeTaste = tagCount;
                    }
                    else
                    {
                        _negativeDelivery = tagCount;
                    }
                }
                
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createPieChart];
            [overlayView dismiss:YES];
        });
        
    }@catch(NSException *e)
    {
        DebugLog(@"FeedbackViewController [feedbackTags]: %@ %@",e.name, e.reason);
        [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
    }
    @finally
    {
        [overlayView dismiss:YES];
    }
}

-(void)feedback
{
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    @try
    {
        NSString *fromDate = [Constants changeDateFormatForAPI:_dateFrom.currentTitle];
        NSString *toDate = [Constants changeDateFormatForAPI:_dateTo.currentTitle];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?loc_id=%@&fromdate=%@&todate=%@", Constants.FEEDBACK_URL, Constants.LOCATION_ID, fromDate, toDate]];
        NSError *error = nil;
        NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
        
        DebugLog(@"Request %@", url);
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Connect"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        NSArray *feedback = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
        
        if (error != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Validation showSimpleAlertOnViewController:self withTitle:@"Error" andMessage:@"Unable to Process"];
                [overlayView dismiss:YES];
            });
            return;
        }
        
        DebugLog(@"%@", feedback);
        
        _happyValue.text = [NSString stringWithFormat:@"%@%%",[feedback[0] objectForKey:@"goodCount"]];
        _sadValue.text = [NSString stringWithFormat:@"%@%%",[feedback[0] objectForKey:@"badCount"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [overlayView dismiss:YES];
        });
        
    }
    @catch(NSException *e)
    {
        DebugLog(@"FeedbackViewController [feedback]: %@ %@",e.name, e.reason);
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
    _searchTextField.text = @"";
    [_positiveFeedbackView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [_positiveFeedbackView addSubview: _happySmiley];
    [_positiveFeedbackView addSubview: _happyValue];
    
    [_negativeFeedbackView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [_negativeFeedbackView addSubview: _sadSmiley];
    [_negativeFeedbackView addSubview: _sadValue];
    
    [self feedbackTags];
    [self feedback];
    [self totalOrdersList];
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
        [_feedbackTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        NSNumber *temp = [NSNumber numberWithInt:[[_searchResultArray objectAtIndex:0]intValue]];
        [_searchResultArray removeObjectAtIndex:0];
        [_searchResultArray addObject:temp];
    }
    else
    {
        _searchString = [Validation trim:_searchTextField.text];
        [_searchResultArray removeAllObjects];
        
        for (int i = 0; i<_feedbackArray.count; i++)
        {
            Feedback *feedback = _feedbackArray[i];
            
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
            [_feedbackTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            
            NSNumber *temp = [NSNumber numberWithInt:[[_searchResultArray objectAtIndex:0]intValue]];
            [_searchResultArray removeObjectAtIndex:0];
            [_searchResultArray addObject:temp];
        }
    }
    
}

-(NSString *)convertDate:(NSString *) dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-ddHH:mm:ss.SS"];
    
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MMM dd, HH:mm"];
    return [dateFormatter1 stringFromDate:dateFromString];
}

@end
