//
//  Note+Additions.h
//  Sticky Notes
//
//  Created by Ste Prescott on 07/12/2013.
//  Copyright (c) 2013 ste.me. All rights reserved.
//

#import "Note.h"

@interface Note (Additions)

+ (BOOL)createOrUpdateNoteWithID:(NSString *)noteID title:(NSString *)noteTitle body:(NSString *)noteBody;
+ (NSArray *)allNotesWithNoUser;

@end
