//
//  NoteViewController.m
//  Sticky Notes
//
//  Created by Ste Prescott on 21/03/2014.
//  Copyright (c) 2014 ste.me. All rights reserved.
//

#import "NoteViewController.h"

#import "NSAttributedString+Addtions.h"

#import "CoreDataCategories.h"
#import "SKCoreDataManager.h"

@interface NoteViewController ()

@end

@implementation NoteViewController

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
	[_noteTitleTextView setText:[_note noteTitle]];
	[_textView setAttributedText:[_note noteBody]];
}

- (void)setEnabled:(BOOL)enabled
{
	_enabled = enabled;
	
	if(_enabled)
	{
		[_textView setUserInteractionEnabled:YES];
		[_noteTitleTextView setUserInteractionEnabled:YES];
	}
	else
	{
		[_textView setUserInteractionEnabled:NO];
		[_noteTitleTextView setUserInteractionEnabled:NO];
	}
}

- (IBAction)deleteButtonPressed:(id)sender
{
	[_textView resignFirstResponder];
	[_noteTitleTextView resignFirstResponder];
	
	if([_note authorID] == [[User activeUser] userID])
	{
		if(_delegate && [_delegate respondsToSelector:@selector(noteDeleted)])
		{
			
			[Note deleteNote:_note
					 forUser:[User activeUser]
					 success:^{
						 [_delegate noteDeleted];
						 [SVProgressHUD showSuccessWithStatus:@"Note deleted"];
					 } failure:^(NSError *error) {
						 NSLog(@"Could not delete note");
						 [SVProgressHUD showErrorWithStatus:@"Could not delete note"];
					 }];
		}
	}
	else
	{
		[SVProgressHUD showErrorWithStatus:@"This is not your\nnote to delete"];
	}
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
	[UIView animateWithDuration:0.25
						  delay:0
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 [_textView setFrame:CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y, _textView.frame.size.width, (_textView.frame.size.height - 258))];
					 } completion:nil];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
	[UIView animateWithDuration:0.25
						  delay:0
						options:UIViewAnimationOptionCurveLinear
					 animations:^{
						 [_textView setFrame:CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y, _textView.frame.size.width, (_textView.frame.size.height + 258))];
					 } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
