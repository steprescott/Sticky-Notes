//
//  NoteViewController.h
//  Sticky Notes
//
//  Created by Ste Prescott on 21/03/2014.
//  Copyright (c) 2014 ste.me. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KLNoteViewController.h"
#import "NotesForBoardViewController.h"

#import "RichTextEditor.h"

@class Note;

@interface NoteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *noteTitleTextView;
@property (weak, nonatomic) IBOutlet RichTextEditor *textView;

@property (assign) id <NotesForBoardViewControllerDelegate, UITextViewDelegate> delegate;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, strong) Note *note;

- (IBAction)deleteButtonPressed:(id)sender;

@end
