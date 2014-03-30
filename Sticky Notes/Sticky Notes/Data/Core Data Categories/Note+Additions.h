//
//  Note+Additions.h
//  Sticky Notes
//
//  Created by Ste Prescott on 07/12/2013.
//  Copyright (c) 2013 ste.me. All rights reserved.
//

#import "Note.h"

typedef void(^UploadNoteSuccess)(Note *note);
typedef void(^NotesForUserOnBoardSuccess)(NSDictionary *notes);
typedef void(^DeleteNoteSuccess)();

typedef void(^NoteFailure)(NSError *error);

@class Board;

@interface Note (Additions)

+ (Note *)noteWithNoteID:(NSNumber *)noteID;
+ (Note *)createOrUpdateNoteWithID:(NSNumber *)noteID title:(NSString *)noteTitle body:(NSAttributedString *)noteBody noteDate:(NSDate *)date authorID:(NSNumber *)authorID boardID:(NSNumber *)boardID;
+ (void)uploadNote:(Note *)note toBoard:(Board *)board forUser:(User *)user success:(UploadNoteSuccess)successBlock failure:(NoteFailure)failureBlock;
+ (void)notesForUser:(User *)user onBoard:(Board *)board success:(NotesForUserOnBoardSuccess)successBlock failure:(NoteFailure)failureBlock;
+ (NSArray *)allNotesWithNoUser;
+ (void)deleteNote:(Note *)note forUser:(User *)user success:(DeleteNoteSuccess)successBlock failure:(NoteFailure)failureBlock;
@end
