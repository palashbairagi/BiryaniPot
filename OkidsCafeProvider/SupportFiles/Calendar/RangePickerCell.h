//
//  RangePickerCell.h
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 5/13/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <FSCalendar/FSCalendar.h>

@interface RangePickerCell : FSCalendarCell

// The start/end of the range
@property (weak, nonatomic) CALayer *selectionLayer;

// The middle of the range
@property (weak, nonatomic) CALayer *middleLayer;

@end
