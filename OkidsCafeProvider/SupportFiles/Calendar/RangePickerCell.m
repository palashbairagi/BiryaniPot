//
//  RangePickerCell.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 5/13/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "RangePickerCell.h"
#import "FSCalendarExtensions.h"

@implementation RangePickerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CALayer *selectionLayer = [[CALayer alloc] init];
        selectionLayer.backgroundColor = [UIColor orangeColor].CGColor;
        selectionLayer.cornerRadius = 25;
        selectionLayer.actions = @{@"hidden":[NSNull null]}; // Remove hiding animation
        [self.contentView.layer insertSublayer:selectionLayer below:self.titleLabel.layer];
        self.selectionLayer = selectionLayer;
        
        CALayer *middleLayer = [[CALayer alloc] init];
        middleLayer.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3].CGColor;
        middleLayer.cornerRadius = 25;
        middleLayer.actions = @{@"hidden":[NSNull null]}; // Remove hiding animation
        [self.contentView.layer insertSublayer:middleLayer below:self.titleLabel.layer];
        self.middleLayer = middleLayer;
        
        // Hide the default selection layer
        self.shapeLayer.hidden = YES;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = self.contentView.bounds;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    self.selectionLayer.frame = self.contentView.bounds;
    self.middleLayer.frame = self.contentView.bounds;
}

@end
