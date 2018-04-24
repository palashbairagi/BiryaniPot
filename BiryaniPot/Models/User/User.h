//
//  User.h
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/28/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * profilePictureURL;
@property (nonatomic, retain) UIImage *profilePicture;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * role;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * licenseNumber;
@end
