//
//  RadialGradientView.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/23/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "RadialGradientView.h"

@implementation RadialGradientView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw A Gradient from yellow to Orange
    NSArray *colors = [NSArray arrayWithObjects:(id)[UIColor yellowColor].CGColor, (id)[UIColor orangeColor].CGColor, nil];
    
    CGColorSpaceRef myColorspace=CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef myGradient = CGGradientCreateWithColors(myColorspace, (CFArrayRef) colors, nil);
    
    double circleWidth = self.viewForFirstBaselineLayout.frame.size.width;
    double circleHeight = self.viewForFirstBaselineLayout.frame.size.height;
    
    CGPoint theCenter = CGPointMake(circleWidth/2, circleHeight/2);
    
    // Account for orientation changes
    double radius = circleHeight;
    
    if (circleHeight < circleWidth) {
        radius = circleWidth;
    }
    
    CGGradientDrawingOptions options = kCGGradientDrawsBeforeStartLocation;
    CGContextDrawRadialGradient(context, myGradient, theCenter, 0.0, theCenter, radius/1.3, options);
}

@end
