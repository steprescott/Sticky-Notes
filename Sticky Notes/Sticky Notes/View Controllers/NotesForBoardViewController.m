//
//  NotesForBoardViewController.m
//  Sticky Notes
//
//  Created by Ste Prescott on 20/03/2014.
//  Copyright (c) 2014 ste.me. All rights reserved.
//

#import "NotesForBoardViewController.h"
#import "NoteViewController.h"
#import "REFrostedViewController.h"

#import "CoreDataCategories.h"
#import "SKCoreDataManager.h"

#import "NSAttributedString+Addtions.h"

@interface NotesForBoardViewController ()

@property (weak, nonatomic) IBOutlet UILabel *boardNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *addNoteButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteBoardButton;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;

@property (nonatomic, strong) NSArray *notes;

@end

@implementation NotesForBoardViewController

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

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if(![User activeUser])
	{
		UIViewController *login = [[self storyboard] instantiateViewControllerWithIdentifier:@"loginViewController"];
		[[self navigationController] presentViewController:login animated:NO completion:nil];
	}

	if(!_board)
	{
		[_boardNameLabel setText:@""];
		[_infoLabel setText:@"Please select a board or create a new one from the menu"];
		[_infoLabel setAlpha:1.0];
		
		[_boardNameLabel setAlpha:0.0];
		[_addNoteButton setAlpha:0.0];
		[_inviteButton setAlpha:0.0];
		[_deleteBoardButton setAlpha:0.0];
	}
}

- (void)setBoard:(Board *)board
{
	_board = board;
	
	self.notes = [[[_board notes] allObjects] sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"noteDate" ascending:YES selector:@selector(compare:)]]];
	
	if(_board)
	{
		[Board usersForBoard:_board
					 forUser:[User activeUser]
					 success:^(NSArray *usersForBoard) {
						 [board addUsers:[NSSet setWithArray:usersForBoard]];
					 } failure:^(NSError *error) {
						 NSLog(@"Could not load users for board");
						 [SVProgressHUD showErrorWithStatus:@"Could not load your boards"];
					 }];
		
		[_boardNameLabel setText:[_board boardName]];
		
		if([[_board notes] count] == 0)
		{
			[_infoLabel setText:@"Tap the + button to add\na new note"];
			
			[UIView animateWithDuration:0.5
							 animations:^{
								 [_infoLabel setAlpha:1.0];
							 }];
		}
		else
		{
			[UIView animateWithDuration:0.5
							 animations:^{
								 [_infoLabel setAlpha:0.0];
							 } completion:^(BOOL finished) {
								 [_infoLabel setText:@""];
							 }];
		}
		
		if([board boardOwnerUserID] == [[User activeUser] userID])
		{
			[_deleteBoardButton setTitle:@"Delete board" forState:UIControlStateNormal];
		}
		else
		{
			[_deleteBoardButton setTitle:@"Leave board" forState:UIControlStateNormal];
		}
		
		[UIView animateWithDuration:0.5
						 animations:^{
							 [_boardNameLabel setAlpha:1.0];
							 [_addNoteButton setAlpha:1.0];
							 [_inviteButton setAlpha:1.0];
							 [_deleteBoardButton setAlpha:1.0];
						 }];
	}
	else
	{
		[_infoLabel setText:@"Please select a board or create a new one from the menu"];
		[_infoLabel setAlpha:1.0];
		
		[UIView animateWithDuration:0.5
						 animations:^{
							 [_boardNameLabel setAlpha:0.0];
							 [_addNoteButton setAlpha:0.0];
							 [_inviteButton setAlpha:0.0];
							 [_deleteBoardButton setAlpha:0.0];
						 }completion:^(BOOL finished) {
							 [_boardNameLabel setText:@""];
						 }];
	}
	
	[self reloadDataAnimated:YES];
}

- (IBAction)newNoteButtonPressed:(id)sender
{
	Note *note = [Note createOrUpdateNoteWithID:nil
										  title:@""
										   body:[[NSAttributedString alloc] initWithString:@""]
									   noteDate:[NSDate new]
									   authorID:[[User activeUser] userID]
										boardID:[_board boardID]];
	
	[Note uploadNote:note
			 toBoard:_board
			 forUser:[User activeUser]
			 success:^(Note *note) {
				 [note setHasBeenUploaded:[NSNumber numberWithBool:YES]];
				 [[self navigationController] popViewControllerAnimated:YES];
			 } failure:^(NSError *error) {
				 [note setHasBeenUploaded:[NSNumber numberWithBool:NO]];
				 [[self navigationController] popViewControllerAnimated:YES];
				 [SVProgressHUD showErrorWithStatus:@"Could not upload note"];
			 }];
	
	self.notes = [[[_board notes] allObjects] sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"noteDate" ascending:YES selector:@selector(compare:)]]];
	
	[self reloadDataAnimated:YES];
	
	[UIView animateWithDuration:0.5
					 animations:^{
						 [_infoLabel setAlpha:0.0];
					 } completion:^(BOOL finished) {
						 [_infoLabel setText:@""];
					 }];
}

- (IBAction)menuButtonPressed:(id)sender
{
	[self.frostedViewController presentMenuViewController];
}

- (IBAction)deleteBoardButtonPressed:(id)sender
{
	if([_board boardOwnerUserID] == [[User activeUser] userID])
	{
		[Board deleteBoard:_board
				   forUser:[User activeUser]
				   success:^{
					   self.board = nil;
					   [SVProgressHUD showSuccessWithStatus:@"Board deleted"];
				   }
				   failure:^(NSError *error) {
					   NSLog(@"Could not delete board");
					   [SVProgressHUD showErrorWithStatus:@"Could not delete board"];
				   }];
	}
	else
	{
		[Board leaveBoard:_board
				   forUser:[User activeUser]
				   success:^{
					   self.board = nil;
					   [SVProgressHUD showSuccessWithStatus:@"Left board"];
				   }
				   failure:^(NSError *error) {
					   NSLog(@"Could not leave board");
					   [SVProgressHUD showErrorWithStatus:@"Could not leave board"];
				   }];
	}
}

- (IBAction)inviteButtonPressed:(id)sender
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invite user"
													message: @"Please enter the email address of\nthe user you wish to invite."
												   delegate: self
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles:@"Invite", nil];
	
	[alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
	[alert show];
}

- (NSInteger)numberOfControllerCardsInNoteView:(KLNoteViewController*) noteView
{
    return  [_notes count];
}

- (UIViewController *)noteView:(KLNoteViewController *)noteView viewControllerAtIndex:(NSInteger)index
{
	UINavigationController *navController = (UINavigationController *)[[self storyboard] instantiateViewControllerWithIdentifier:@"noteCard"];
	
	NoteViewController *noteViewController = (NoteViewController *)[navController viewControllers][0];
	[noteViewController setNote:_notes[index]];
	[noteViewController setDelegate:self];
	return navController;
}

-(void) noteViewController: (KLNoteViewController*) noteViewController didUpdateControllerCard:(KLControllerCard*)controllerCard toDisplayState:(KLControllerCardState) toState fromDisplayState:(KLControllerCardState) fromState
{
	UINavigationController *navController = (UINavigationController *)[controllerCard viewController];
	NoteViewController *noteView = (NoteViewController *)[navController viewControllers][0];
	Note *note = [noteView note];
	
	switch (toState) {
		
		case KLControllerCardStateDefault:
		{
			if([note authorID] == [[User activeUser] userID])
			{
				if(![[[noteView textView] text] isEqualToString:@""] || ![[[noteView noteTitleTextView] text] isEqualToString:@""])
				{
					[Note createOrUpdateNoteWithID:[note noteID]
											 title:[[noteView noteTitleTextView] text]
											  body:[[noteView textView] attributedText]
										  noteDate:[NSDate new]
										  authorID:[[User activeUser] userID]
										   boardID:[_board boardID]];
					
					[Note uploadNote:note
							 toBoard:_board
							 forUser:[User activeUser]
							 success:^(Note *note) {
								 [note setHasBeenUploaded:[NSNumber numberWithBool:YES]];
								 [[self navigationController] popViewControllerAnimated:YES];
							 } failure:^(NSError *error) {
								 [note setHasBeenUploaded:[NSNumber numberWithBool:NO]];
								 [[self navigationController] popViewControllerAnimated:YES];
							 }];
				}
			}
			
			[noteView setEnabled:NO];
			break;
		}
		
		case KLControllerCardStateFullScreen:
		{
			if([note authorID] == [[User activeUser] userID])
			{
				[noteView setEnabled:YES];
			}
			else
			{
				[SVProgressHUD showErrorWithStatus:@"Read only"];
			}
			break;
		}
	}
}

- (void)noteDeleted
{
	self.notes = [[[_board notes] allObjects] sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"noteDate" ascending:YES selector:@selector(compare:)]]];;
	
	if([_notes count] == 0)
	{
		[_infoLabel setText:@"Tap the + button to add\na new note"];
		[UIView animateWithDuration:0.5
						 animations:^{
							 [_infoLabel setAlpha:1.0];
						 }];
	}
	else
	{
		[UIView animateWithDuration:0.5
						 animations:^{
							 [_infoLabel setAlpha:0.0];
						 } completion:^(BOOL finished) {
							 [_infoLabel setText:@""];
						 }];
	}
	
	[self reloadDataAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != [alertView cancelButtonIndex])
	{
		NSString *usersEmailAddress = [[alertView textFieldAtIndex:0] text];
		
		if(![usersEmailAddress isEqualToString:@""])
		{
			__block BOOL isUserAlreadyInBoard = NO;
			
			[[_board users] enumerateObjectsUsingBlock:^(User *user, BOOL *stop) {
				if([[user email] isEqualToString:usersEmailAddress])
				{
					isUserAlreadyInBoard = YES;
					*stop = YES;
				}
			}];
			
			if(isUserAlreadyInBoard)
			{
				[SVProgressHUD showErrorWithStatus:@"User already invited"];
			}
			else
			{
				[Board inviteUserWithEmailAddress:usersEmailAddress
										  toBoard:_board
										  forUser:[User activeUser]
										  success:^{
											  NSLog(@"User added to board");
											  [SVProgressHUD showSuccessWithStatus:@"User invited"];
										  } failure:^(NSError *error) {
											  NSLog(@"Could not invite user to board");
											  [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
										  }];
			}
		}
		else
		{
			[SVProgressHUD showErrorWithStatus:@"No email address entered"];
		}
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
