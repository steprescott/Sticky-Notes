//
//  Note+Additions.m
//  Sticky Notes
//
//  Created by Ste Prescott on 07/12/2013.
//  Copyright (c) 2013 ste.me. All rights reserved.
//

#import "CoreDataCategories.h"
#import "SKCoreDataManager.h"

#import "AFNetworking.h"
#import "Constants.h"

#import "NSAttributedString+Addtions.h"

@implementation Note (Additions)

+ (Note *)noteWithNoteID:(NSNumber *)noteID
{
	return [[Note whereWithFormat:@"noteID == %@", noteID] lastObject];
}

+ (Note *)createOrUpdateNoteWithID:(NSNumber *)noteID title:(NSString *)noteTitle body:(NSAttributedString *)noteBody noteDate:(NSDate *)date authorID:(NSNumber *)authorID boardID:(NSNumber *)boardID
{
	Note *note = [self noteWithNoteID:noteID];
	
    if(!note)
    {
        note = [Note create];
		
		if(noteID)
		{
        	[note setNoteID:noteID];
		}
		else
		{
			[note setNoteID:[NSNumber numberWithLong:(([[Note all] count] + 1)) * -1]];
		}
    }
	
	if(noteTitle && noteTitle != [NSNull null])
	{
		[note setNoteTitle:noteTitle];
	}
    
	if(noteBody && noteBody != [NSNull null])
	{
    	[note setNoteBody:noteBody];
	}
	
	if(authorID && authorID != [NSNull null])
	{
		[note setAuthorID:authorID];
		[note setAuthor:[User userWithID:authorID]];
	}
	
	if(boardID)
	{
		Board *board = [Board boardWithBoardID:boardID];
		if(![[note boards] containsObject:board])
		{
			[note addBoardsObject:[Board boardWithBoardID:boardID]];
		}
	}
    [note setNoteDate:(date) ? date : [NSDate new]];
    
    return [note save] ? note : nil;
}

+ (NSArray *)allNotesWithNoUser
{
    return [Note where:@"user == nil"];
}

+ (void)uploadNote:(Note *)note toBoard:(Board *)board forUser:(User *)user success:(UploadNoteSuccess)successBlock failure:(NoteFailure)failureBlock
{
	if(![board boardID] || ![user token])
	{
		if(failureBlock)
		{
			failureBlock([NSError errorWithDomain:@"stickyNotes"
											 code:001
										 userInfo:@{NSLocalizedDescriptionKey:@"Parameters can not be nil"}]);
		}
		return;
	}
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	if(![note noteID] || [[note noteID] integerValue] < 0)
	{
		NSString *urlAsString = [NSString stringWithFormat:@"%@%@", kBaseURL, kUploadNewNote];
		
		NSDictionary *parameters = @{@"boardID" : [board boardID],
									 @"title" : [note noteTitle],
									 @"body" : [[note noteBody] string],
									 @"token" : [user token]};
		
		[manager POST:urlAsString parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *noteDictionary) {
			
			[note setNoteID:noteDictionary[@"id"]];
			[note save];
			
			if(successBlock)
			{
				successBlock(note);
			}
			
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			
			if(failureBlock)
			{
				failureBlock(error);
			}
		}];
	}
	else
	{
		NSString *urlAsString = [NSString stringWithFormat:@"%@%@", kBaseURL, kUpdateNote];
		
		NSDictionary *parameters = @{@"id" : [note noteID],
									 @"title" : [note noteTitle],
									 @"body" : [[note noteBody] string],
									 @"token" : [user token]};
		
		[manager POST:urlAsString parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *noteDictionary) {

			if(successBlock)
			{
				successBlock(note);
			}
			
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			
			if(failureBlock)
			{
				failureBlock(error);
			}
		}];

	}
}

+ (void)notesForUser:(User *)user onBoard:(Board *)board success:(NotesForUserOnBoardSuccess)successBlock failure:(NoteFailure)failureBlock
{
	if(![board boardID] || ![user token])
	{
		if(failureBlock)
		{
			failureBlock([NSError errorWithDomain:@"stickyNotes"
											 code:001
										 userInfo:@{NSLocalizedDescriptionKey:@"Parameters can not be nil"}]);
		}
		return;
	}
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	NSString *urlAsString = [NSString stringWithFormat:@"%@%@", kBaseURL, kGetNotes];
	
	NSDictionary *parameters = @{@"boardID" : [board boardID],
								 @"token" : [user token]};
	
	[manager POST:urlAsString parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *response) {
		
		if(successBlock)
		{
			successBlock(response);
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		if(failureBlock)
		{
			failureBlock(error);
		}
	}];
}

+ (void)deleteNote:(Note *)note forUser:(User *)user success:(DeleteNoteSuccess)successBlock failure:(NoteFailure)failureBlock
{
	if(![note noteID] || ![user token])
	{
		if(failureBlock)
		{
			failureBlock([NSError errorWithDomain:@"stickyNotes"
											 code:001
										 userInfo:@{NSLocalizedDescriptionKey:@"Parameters can not be nil"}]);
		}
		return;
	}
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	NSString *urlAsString = [NSString stringWithFormat:@"%@%@", kBaseURL, kDeleteNote];
	
	NSDictionary *parameters = @{@"id" : [note noteID],
								 @"token" : [user token]};
	
	[manager POST:urlAsString parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *response) {
		
		[note delete];
		
		if(successBlock)
		{
			successBlock();
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		if(failureBlock)
		{
			failureBlock(error);
		}
	}];
}

@end
