//
//  Note+Additions.m
//  Sticky Notes
//
//  Created by Ste Prescott on 07/12/2013.
//  Copyright (c) 2013 ste.me. All rights reserved.
//

#import "Note+Additions.h"
#import "SKCoreDataManager.h"

@implementation Note (Additions)

+ (BOOL)createOrUpdateNoteWithID:(NSString *)noteID title:(NSString *)noteTitle body:(NSString *)noteBody
{
    Note *note = [[Note whereWithFormat:@"noteID == %@", noteID] lastObject];
    
    if(!note)
    {
        note = [Note create];
        [note setNoteID:[NSString stringWithFormat:@"%lu", ([[Note all] count] + 1)]];
    }
    
    [note setNoteTitle:noteTitle];
    [note setNoteBody:noteBody];
    [note setNoteDate:[NSDate new]];
    
    return [note save];
}

+ (NSArray *)allNotesWithNoUser
{
    return [Note where:@"user == nil"];
}

@end
