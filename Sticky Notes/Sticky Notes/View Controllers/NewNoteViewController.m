//
//  NewNoteViewController.m
//  Sticky Notes
//
//  Created by Ste Prescott on 07/12/2013.
//  Copyright (c) 2013 ste.me. All rights reserved.
//

#import "NewNoteViewController.h"

#import "CoreDataCategories.h"

@interface NewNoteViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UITextField *noteTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *noteBodyTextField;

@property (assign) BOOL isKeyboardShowing;

- (IBAction)saveButtonPressed:(id)sender;

@end

@implementation NewNoteViewController

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
    
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    [_noteTitleTextField addTarget:self action:@selector(keyboardDidShow) forControlEvents:UIControlEventEditingDidBegin];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_note)
    {
        [self setTitle:@"Edit Note"];
        [_noteTitleTextField setText:[_note noteTitle]];
        [_noteBodyTextField setText:[_note noteBody]];
    }
}

- (IBAction)saveButtonPressed:(id)sender
{
    [Note createOrUpdateNoteWithID:[_note noteID] title:[_noteTitleTextField text] body:[_noteBodyTextField text]];
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)keyboardDidShow
{
    if(!_isKeyboardShowing)
    {
        self.isKeyboardShowing = YES;
        
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                              [_scrollview setFrame:CGRectMake(_scrollview.frame.origin.x, _scrollview.frame.origin.y, _scrollview.frame.size.width, (_scrollview.frame.size.height - 210))];
                         } completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
