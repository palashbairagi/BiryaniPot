//
//  CALayer+UIColor.m
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 1/11/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "CALayer+UIColor.h"

@implementation CALayer(UIColor)

- (void)setBorderUIColor:(UIColor*)color {
    self.borderColor = color.CGColor;
}

- (UIColor*)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

-(void)setShadowUIColor:(UIColor*)color
{
    self.shadowColor = color.CGColor;
}

-(UIColor*)shadowUIColor
{
    return [UIColor colorWithCGColor:self.shadowColor];
}

@end
