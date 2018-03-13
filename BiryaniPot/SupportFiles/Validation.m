//
//  Validation.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 2/11/18.
//  Copyright © 2018 Palash Bairagi. All rights reserved.
//

#import "Validation.h"

@implementation Validation

+(void)showSimpleAlertOnViewController:(UIViewController *)viewController withTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:ok];

    [viewController presentViewController:alertController animated:YES completion:nil];
}

+(NSString *)trim:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+(BOOL)isEmpty:(UITextField *)textField
{
    if ([[self trim:textField.text] length] == 0)
    {
        return true;
    }
    else
    {
        return false;
    }
}

+(BOOL)isLess:(UITextField *)textField thanMinLength: (int)minLength
{
    if ([[self trim:textField.text] length] < minLength)
    {
        return true;
    }
    else
    {
        return false;
    }
}

+(BOOL)isMore:(UITextField *)textField thanMaxLength: (int)maxLength
{
    if ([[self trim:textField.text] length] > maxLength)
    {
        return true;
    }
    else
    {
        return false;
    }
}

+(BOOL)isNumber:(UITextField *)textField
{
    NSString *string = [self trim:textField.text];
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];

    if ([string rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        return false;
    }
    else
    {
        return true;
    }
}

+(BOOL)isEmail:(UITextField *)textField
{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([emailTest evaluateWithObject:[self trim:textField.text]] == YES)
    {
        return false;
    }
    else
    {
        return true;
    }
}

@end
