//
//  Validation.h
// OkidsCafeProvider
//
//  Created by Palash Bairagi on 2/11/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Validation : NSObject

+(void)showSimpleAlertOnViewController:(UIViewController *)viewController withTitle:(NSString *)title andMessage:(NSString *)message;
+(NSString *)trim:(NSString *)string;
+(BOOL)isEmpty:(UITextField *)textField;
+(BOOL)isLess:(UITextField *)textField thanMinLength: (int)minLength;
+(BOOL)isMore:(UITextField *)textField thanMaxLength: (int)maxLength;
+(BOOL)isNumber:(UITextField *)textField;
+(BOOL)isDecimal:(UITextField *)textField;
+(BOOL)isEmail:(UITextField *)textField;
@end
