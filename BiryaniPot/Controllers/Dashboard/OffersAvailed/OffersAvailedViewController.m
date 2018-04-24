//
//  OffersAvailedViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/8/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "OffersAvailedViewController.h"
#import "OfferStatistics.h"
#import "Constants.h"

@interface OffersAvailedViewController ()

@end

@implementation OffersAvailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_dateFrom setTitle:Constants.GET_FIFTEEN_DAYS_AGO_DATE forState:UIControlStateNormal];
    [_dateTo setTitle:Constants.GET_TODAY_DATE
             forState:UIControlStateNormal];
    [_dateFrom setTitle:Constants.GET_FIFTEEN_DAYS_AGO_DATE forState:UIControlStateSelected];
    [_dateTo setTitle:Constants.GET_TODAY_DATE forState:UIControlStateSelected];
    
    _offersArray = [[NSMutableArray alloc]init];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self offer];
    [self createLineGraph];
}

-(void)offer
{
    NSString *fromDate = @"2018-01-03";
    NSString *toDate = @"2018-09-01";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?loc_id=%@&from_date=%@&to_date=%@", Constants.OFFER_STATISTICS_URL, Constants.LOCATION_ID, fromDate, toDate]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    NSArray *offers = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    
    for(NSDictionary *offer in offers)
    {
        NSString *codeName = [offer objectForKey:@"codeName"];
        
        OfferStatistics *os = [[OfferStatistics alloc]init];
        os.codeName = codeName;
        os.timesApplied = [offer objectForKey:@"times"];
       
        [_offersArray addObject:os];
    }
}

- (void)createLineGraph{
    MultiLineGraphView *graph = [[MultiLineGraphView alloc] initWithFrame:CGRectMake(10, 10, self.offersAvailedView.frame.size.width-20, self.offersAvailedView.frame.size.height-10)];
    
    [graph setDataSource:self];
    
    [graph setShowLegend:TRUE];
    [graph setLegendViewType:LegendTypeHorizontal];
    
    [graph setDrawGridY:TRUE];
    [graph setDrawGridX:TRUE];
    
    [graph setGridLineColor:[UIColor lightGrayColor]];
    [graph setGridLineWidth:0.3];
    
    [graph setTextFontSize:12];
    [graph setTextColor:[UIColor blackColor]];
    [graph setTextFont:[UIFont systemFontOfSize:graph.textFontSize]];
    
    [graph setMarkerColor:[UIColor orangeColor]];
    [graph setMarkerTextColor:[UIColor whiteColor]];
    [graph setMarkerWidth:0.4];
    [graph setShowMarker:TRUE];
   // [graph showCustomMarkerView:TRUE];
    
    [graph drawGraph];
    [self.offersAvailedView addSubview:graph];
}

- (NSInteger)numberOfLinesToBePlotted
{
    return _offersArray.count;
}

- (LineDrawingType)typeOfLineToBeDrawnWithLineNumber:(NSInteger)lineNumber
{
    return LineDefault;
}

- (UIColor *)colorForTheLineWithLineNumber:(NSInteger)lineNumber
{
    NSInteger aRedValue = arc4random()%255;
    NSInteger aGreenValue = arc4random()%255;
    NSInteger aBlueValue = arc4random()%255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
    return randColor;
}

- (CGFloat)widthForTheLineWithLineNumber:(NSInteger)lineNumber
{
    return 1;
}

- (NSString *)nameForTheLineWithLineNumber:(NSInteger)lineNumber
{
    //return [NSString stringWithFormat:@"Offer %ld",(long)lineNumber];
    OfferStatistics *os = _offersArray[lineNumber];
    return [NSString stringWithFormat:@"%@", os.codeName];
}

- (BOOL)shouldFillGraphWithLineNumber:(NSInteger)lineNumber{
    return false;
}

- (BOOL)shouldDrawPointsWithLineNumber:(NSInteger)lineNumber{
    return false;
}

- (UIView *)customViewForLineChartTouchWithXValue:(NSNumber *)xValue andYValue:(NSNumber *)yValue{
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
    [label setText:[NSString stringWithFormat:@"Line Data: %@", yValue]];
    [label setFrame:CGRectMake(0, 0, 100, 30)];
    [view addSubview:label];
    
    [view setFrame:label.frame];
    return view;
}

- (NSMutableArray *)dataForXAxisWithLineNumber:(NSInteger)lineNumber {
    
    NSString *fromDate = @"2018-01-03";
    NSString *toDate = @"2018-09-01";
    
    NSDate *startDate = [self changeStringToDate:fromDate];
    NSDate *endDate = [self changeStringToDate:toDate];
    
    NSMutableArray *dateList = [[NSMutableArray alloc]init];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    
    [dateList addObject: [self changeDateToString: startDate]];
    
    NSDate *currentDate = startDate;
    // add one the first time through, so that we can use NSOrderedAscending (prevents millisecond infinite loop)
    currentDate = [currentCalendar dateByAddingComponents:comps toDate:currentDate  options:0];
    
    while ( [endDate compare: currentDate] != NSOrderedAscending)
    {
        [dateList addObject: [self changeDateToString: currentDate]];
        currentDate = [currentCalendar dateByAddingComponents:comps toDate:currentDate  options:0];
    }

    return dateList;
}

- (NSMutableArray *)dataForYAxisWithLineNumber:(NSInteger)lineNumber {
    
    NSString *fromDate = @"2018-01-03";
    NSString *toDate = @"2018-09-01";
    
    NSDate *startDate = [self changeStringToDate:fromDate];
    NSDate *endDate = [self changeStringToDate:toDate];
    
    OfferStatistics *os = _offersArray[lineNumber];
    
    NSMutableArray *timesAppliedArray = os.timesApplied;
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    NSMutableArray *dateList = [[NSMutableArray alloc]init];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    
    [dateList addObject: [self changeDateToString: startDate]];
    
    NSDate *currentDate = startDate;
    // add one the first time through, so that we can use NSOrderedAscending (prevents millisecond infinite loop)
    currentDate = [currentCalendar dateByAddingComponents:comps toDate:currentDate  options:0];
    
    while ( [endDate compare: currentDate] != NSOrderedAscending)
    {
        [dateList addObject: [self changeDateToString: currentDate]];
        currentDate = [currentCalendar dateByAddingComponents:comps toDate:currentDate  options:0];
    }
    
    
    
    for (int j = 0; j < dateList.count; j++)
    {
        BOOL found = FALSE;
        
        for (int i = 0; i < timesAppliedArray.count; i++)
        {
            NSString *appliedDate = [ self changeDateToString:[self changeStringToDate:[timesAppliedArray[i] objectForKey:@"appliedDate"]]];
            
            if ([dateList[j] isEqualToString:appliedDate])
            {
                NSString *timesApplied = [timesAppliedArray[i] objectForKey:@"timesApplied"];
                [resultArray addObject: [NSString stringWithFormat:@"%@", timesApplied]];
                found = TRUE;
                break;
            }
        }
        
        if (!found)
        {
            [resultArray addObject:@"0"];
        }
    }
    
    return resultArray;
}

-(NSDate *) changeStringToDate: (NSString *)str
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *date = [formatter dateFromString:str];
    
    return date;
}

-(NSString *) changeDateToString: (NSDate *) date
{
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"MMM dd"];
    return [dateformate stringFromDate:date];
}



@end
