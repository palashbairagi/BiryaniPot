//
//  OffersAvailedViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 1/8/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "OffersAvailedViewController.h"

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
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self createLineGraph];
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
    return 3;
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
    return [NSString stringWithFormat:@"Offer %ld",(long)lineNumber];
}

- (BOOL)shouldFillGraphWithLineNumber:(NSInteger)lineNumber{
    return false;
}

- (BOOL)shouldDrawPointsWithLineNumber:(NSInteger)lineNumber{
    return true;
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
    switch (lineNumber) {
        case 0:
        {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i = 21; i <= 30; i++) {
                [array addObject:[NSString stringWithFormat:@"%d Jan", i]];
            }
            return array;
        }
            break;
        case 1:
        {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i = 1; i <= 30; i++) {
                [array addObject:[NSString stringWithFormat:@"%d Jan", i]];
            }
            return array;
        }
            break;
        case 2:
        {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i = 1; i <= 30; i++) {
                [array addObject:[NSString stringWithFormat:@"%d Jan", i]];
            }
            return array;
        }
            break;
    }
    return [[NSMutableArray alloc] init];
}


- (NSMutableArray *)dataForYAxisWithLineNumber:(NSInteger)lineNumber {
    switch (lineNumber) {
        case 0:
        {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i = 20; i < 30; i++) {
                [array addObject:[NSNumber numberWithLong:random()%100]];
            }
            return array;
        }
            break;
        case 1:
        {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i = 0; i < 10; i++) {
                [array addObject:[NSNumber numberWithLong:random()%100]];
            }
            return array;
        }
            break;
        case 2:
        {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i = 0; i < 30; i++) {
                [array addObject:[NSNumber numberWithLong:random()%100]];
            }
            return array;
        }
            break;
    }
    return [[NSMutableArray alloc] init];
}

@end
