//
//  RegisterViewController.m
//  Sticky Notes
//
//  Created by Ste Prescott on 11/02/2014.
//  Copyright (c) 2014 ste.me. All rights reserved.
//

#import "RegisterViewController.h"

#import "TextFieldTableViewCell.h"

#import "User+Additions.h"

//Table view sections
typedef NS_ENUM(NSInteger, TableViewRow)
{
	TableViewRowEmail = 0,
	TableViewRowFirstName,
	TableViewRowLastName,
	TableViewRowPassword,
	TableViewRowReEnterPassword,
	TableViewRowCount
};

static NSString *cellIdentifier = @"register_cell_identifier";

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *textFields;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction)registerButtonPressed:(id)sender;

@end

@implementation RegisterViewController

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
	
	self.textFields = [@[] mutableCopy];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if(_user)
	{
		[_textFields[0] setText:[_user email]];
		[_textFields[1] setText:[_user firstName]];
		[_textFields[2] setText:[_user surname]];
		[_registerButton setTitle:@"Update" forState:UIControlStateNormal];
		[self setTitle:@"Update account"];
		
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonPressed)];
		
		[[self navigationItem] setRightBarButtonItem:cancelButton];
	}
}

- (IBAction)registerButtonPressed:(id)sender
{
	NSString *email = [_textFields[0] text];
	NSString *firstName = [_textFields[1] text];
	NSString *lastName = [_textFields[2] text];
	NSString *password = [_textFields[3] text];
	NSString *reEnterPassword = [_textFields[4] text];
	
	if(![email isEqualToString:@""])
	{
		if(![firstName isEqualToString:@""])
		{
			if(![lastName isEqualToString:@""])
			{
				if(![password isEqualToString:@""])
				{
					if([password isEqualToString:reEnterPassword])
					{
						if(!_user)
						{
							//All it good
							[User registerUserWithFirstname:firstName
												   lastName:lastName
													  email:email
												   password:password
													success:^(User *user) {
														[User loginUserWithUsername:[user email]
																		   password:password
																			success:^(User *activeUser) {
																				[[self navigationController] dismissViewControllerAnimated:YES completion:nil];
																			}
																			failure:^(NSError *error) {
																				NSLog(@"Could not login");
																				[SVProgressHUD showErrorWithStatus:@"Failed to log in"];
																			}];
													}
													failure:^(NSError *error) {
														NSLog(@"Error : %@", [error localizedDescription]);
														[SVProgressHUD showErrorWithStatus:[error localizedDescription]];
													}];
						}
						else
						{
							[User updateUser:_user
							   withFirstname:[_textFields[1] text]
									lastName:[_textFields[2] text]
									   email:[_textFields[0] text]
									 success:^(User *activeUser) {
										 [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
										 [SVProgressHUD showSuccessWithStatus:@"Account updated"];
									 } failure:^(NSError *error) {
										 [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
									 }];
						}
					}
					else
					{
						//Password miss-match
						[_textFields[3] becomeFirstResponder];
						[_textFields[3] setText:@""];
						[_textFields[4] setText:@""];
						[SVProgressHUD showErrorWithStatus:@"Password missmatch"];
					}
				}
				else
				{
					//No password
					[_textFields[3] becomeFirstResponder];
					[SVProgressHUD showErrorWithStatus:@"Password needed"];
				}
			}
			else
			{
				//No last name
				[_textFields[2] becomeFirstResponder];
				[SVProgressHUD showErrorWithStatus:@"Last name needed"];
			}
		}
		else
		{
			//No first name
			[_textFields[1] becomeFirstResponder];
			[SVProgressHUD showErrorWithStatus:@"First name needed"];
		}
	}
	else
	{
		//No email
		[_textFields[0] becomeFirstResponder];
		[SVProgressHUD showErrorWithStatus:@"Email needed"];
	}
}

#pragma mark - UITableViewControllerDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return TableViewRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell == nil)
	{
		cell = [[TextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
	
	if(![_textFields containsObject:[cell textField]])
	{
		[_textFields addObject:[cell textField]];
	}
	
	switch([indexPath row])
	{
		case TableViewRowEmail:
		{
			[[cell textField] setPlaceholder:@"Email"];
			[[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
			[[cell textField] setReturnKeyType:UIReturnKeyNext];
			[[cell textField] setDelegate:self];
			break;
		}
			
		case TableViewRowFirstName:
		{
			[[cell textField] setPlaceholder:@"First name"];
			[[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
			[[cell textField] setReturnKeyType:UIReturnKeyNext];
			[[cell textField] setDelegate:self];
			break;
		}
			
		case TableViewRowLastName:
		{
			[[cell textField] setPlaceholder:@"Last name"];
			[[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
			[[cell textField] setReturnKeyType:UIReturnKeyNext];
			[[cell textField] setDelegate:self];
			break;
		}
			
		case TableViewRowPassword:
		{
			[[cell textField] setPlaceholder:@"Password"];
			[[cell textField] setSecureTextEntry:YES];
			[[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
			[[cell textField] setReturnKeyType:UIReturnKeyNext];
			[[cell textField] setDelegate:self];
			break;
		}
			
		case TableViewRowReEnterPassword:
		{
			[[cell textField] setPlaceholder:@"Re-type password"];
			[[cell textField] setSecureTextEntry:YES];
			[[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
			[[cell textField] setDelegate:self];
			break;
		}
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	
    TextFieldTableViewCell *cell = (TextFieldTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if(![[cell textField] isFirstResponder])
    {
        [[cell textField] becomeFirstResponder];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if(_tableView.frame.size.height == self.view.frame.size.height)
	{
		[UIView animateWithDuration:0.25
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 [_tableView setFrame:CGRectMake(0, 0, _tableView.frame.size.width, _tableView.frame.size.height - 215)];
						 } completion:nil];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	NSInteger idx = [_textFields indexOfObject:textField];
	
	if(idx < ([_textFields count] - 1))
	{
		[_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idx + 1 inSection:0]
						  atScrollPosition:UITableViewScrollPositionMiddle
								  animated:YES];
		
		UITextField *nextField = _textFields[idx + 1];
		[nextField becomeFirstResponder];
	}
	else
	{
		[textField resignFirstResponder];
		[UIView animateWithDuration:0.25
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 [_tableView setFrame:CGRectMake(0, 0, _tableView.frame.size.width, _tableView.frame.size.height + 215)];
						 } completion:nil];
	}
	return NO;
}

- (void)cancelButtonPressed
{
	[[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
