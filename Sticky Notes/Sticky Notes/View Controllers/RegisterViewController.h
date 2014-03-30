//
//  RegisterViewController.h
//  Sticky Notes
//
//  Created by Ste Prescott on 11/02/2014.
//  Copyright (c) 2014 ste.me. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface RegisterViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) User *user;

- (void)cancelButtonPressed;

@end
