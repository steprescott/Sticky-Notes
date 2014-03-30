//
//  NotesForBoardViewController.h
//  Sticky Notes
//
//  Created by Ste Prescott on 20/03/2014.
//  Copyright (c) 2014 ste.me. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KLNoteViewController.h"

@protocol NotesForBoardViewControllerDelegate <NSObject>

- (void)noteDeleted;

@end

@class Board;

@interface NotesForBoardViewController : KLNoteViewController <KLNoteViewControllerDataSource, KLNoteViewControllerDelegate, NotesForBoardViewControllerDelegate>

@property (nonatomic, strong) Board *board;

- (IBAction)newNoteButtonPressed:(id)sender;
- (IBAction)menuButtonPressed:(id)sender;
- (IBAction)deleteBoardButtonPressed:(id)sender;
- (IBAction)inviteButtonPressed:(id)sender;


@end
