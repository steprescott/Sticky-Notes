//
//  LoginViewController.m
//  Sticky Notes
//
//  Created by Ste Prescott on 07/12/2013.
//  Copyright (c) 2013 ste.me. All rights reserved.
//

#import "LoginViewController.h"

#import "SKCoreDataManager.h"
#import "CoreDataCategories.h"

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
			[User loginUserWithUsername:username
							   password:password
								success:^(User *activeUser) {
									NSLog(@"User : %@", activeUser);
									
									[Board boardsForUser:activeUser success:^(NSDictionary *boardsDictionary) {
										NSLog(@"Boards %@", boardsDictionary);
										
										[boardsDictionary[@"boards"] enumerateObjectsUsingBlock:^(NSDictionary *boardDictionary, NSUInteger idx, BOOL *stop) {
											NSNumber *boardID = boardDictionary[@"id"];
											NSString *boardName = boardDictionary[@"name"];
											NSNumber *boardOwnerUserID = boardDictionary[@"owner_user_id"];
											
											[Board createOrUpdateBoardWithID:boardID
																   boardName:boardName
															boardOwnerUserID:boardOwnerUserID];
										}];
										
										[self dismissViewControllerAnimated:YES completion:nil];
										
									} failure:^(NSError *error) {
										NSLog(@"Boards error : %@", [error localizedDescription]);
										[SVProgressHUD showErrorWithStatus:@"Could not load your boards"];
									}];
									
								} failure:^(NSError *error) {
									NSLog(@"Error: %@", error);
									[SVProgressHUD showErrorWithStatus:@"Incorrect username\nor password"];
								}];
		}
		else
		{
			NSLog(@"No password");
			[SVProgressHUD showErrorWithStatus:@"No password"];
		}
	}
	else
	{
		NSLog(@"No username");
		[SVProgressHUD showErrorWithStatus:@"No username"];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
