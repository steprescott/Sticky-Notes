//
//  LoginViewController.m
//  Sticky Notes
//
//  Created by Ste Prescott on 07/12/2013.
//  Copyright (c) 2013 ste.me. All rights reserved.
//

#import "LoginViewController.h"
#import "User+Additions.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)loginButtonPressed:(id)sender;

@end

@implementation LoginViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)loginButtonPressed:(id)sender
{
	NSString *username = [_usernameTextField text];
	NSString *password = [_passwordTextField text];
	
	if(![username isEqualToString:@""])
	{
		if(![password isEqualToString:@""])
		{
			NSLog(@"Try to validate user");
			[User loginUserWithUsername:username
							   password:password
								success:^(User *activeUser) {
									NSLog(@"User : %@", activeUser);
								} failure:^(NSError *error) {
									NSLog(@"Error: %@", error);
								}];
		}
		else
		{
			NSLog(@"No password");
		}
	}
	else
	{
		NSLog(@"No username");
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
