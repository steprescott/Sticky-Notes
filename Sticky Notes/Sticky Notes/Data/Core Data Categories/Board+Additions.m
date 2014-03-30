//
//  Board+Additions.m
//  Sticky Notes
//
//  Created by Ste Prescott on 18/02/2014.
//  Copyright (c) 2014 ste.me. All rights reserved.
//

#import "CoreDataCategories.h"
#import "SKCoreDataManager.h"

#import "AFNetworking.h"
#import "Constants.h"

@implementation Board (Additions)

+ (Board *)createOrUpdateBoardWithID:(NSNumber *)boardID boardName:(NSString *)boardName boardOwnerUserID:(NSNumber *)boardOwnerUserID
{
	Board *board = [self boardWithBoardID:boardID];
	
	if(!board)
	{
		board = [Board create];
		[board setBoardID:boardID];
	}
	
	[board setBoardName:boardName];
	[board setBoardOwnerUserID:boardOwnerUserID];
	[board addUsersObject:[User activeUser]];
	
    return [board save] ? board : nil;
}

+ (Board *)boardWithBoardID:(NSNumber *)boardID
{
	if(!boardID)
	{
		return nil;
	}
	
	return [[Board whereWithFormat:@"boardID == %d", [boardID longValue]] lastObject];
}

+ (void)boardsForUser:(User *)user success:(BoardsForUserSuccess)successBlock failure:(BoardsFailure)failureBlock
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	NSString *urlAsString = [NSString stringWithFormat:@"%@%@", kBaseURL, kGetBoards];
	
	NSDictionary *parameters = @{@"token" : [user token]};
	
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

+ (Board *)anyBoard
{
	return [[Board all] firstObject];
}

+ (void)uploadBoard:(Board *)board forUser:(User *)user success:(UploadBoardSuccess)successBlock failure:(BoardsFailure)failureBlock
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	NSString *urlAsString = [NSString stringWithFormat:@"%@%@", kBaseURL, kUploadBoards];
	
	NSDictionary *parameters = @{@"name" : [board boardName],
								 @"token" : [user token]};
	
	[manager POST:urlAsString parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *boardDictionary) {
		
		[board setBoardID:boardDictionary[@"id"]];
		[board setBoardOwnerUserID:boardDictionary[@"owner_user_id"]];
		[board save];
		
		if(successBlock)
		{
			successBlock(board);
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		NSString *errorMessage = [operation responseObject][@"message"];
		
		if(errorMessage)
		{
			error = [NSError errorWithDomain:@"stickyNotes"
										code:[[operation response] statusCode]
									userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
		}
		
		if(failureBlock)
		{
			failureBlock(error);
		}
	}];
}

+ (void)deleteBoard:(Board *)board forUser:(User *)user success:(DeleteBoardSuccess)successBlock failure:(BoardsFailure)failureBlock
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	NSString *urlAsString = [NSString stringWithFormat:@"%@%@", kBaseURL, kDeleteBoard];
	
	NSDictionary *parameters = @{@"id" : [board boardID],
								 @"token" : [user token]};
	
	[manager POST:urlAsString parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *boardDictionary) {
		
		[board delete];
		
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

+ (void)leaveBoard:(Board *)board forUser:(User *)user success:(LeaveBoardSuccess)successBlock failure:(BoardsFailure)failureBlock
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	NSString *urlAsString = [NSString stringWithFormat:@"%@%@", kBaseURL, kLeaveBoard];
	
	NSDictionary *parameters = @{@"id" : [board boardID],
								 @"token" : [user token]};
	
	[manager POST:urlAsString parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *boardDictionary) {
		
		[board delete];
		
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

+ (void)usersForBoard:(Board *)board forUser:(User *)user success:(UsersForBoardSuccess)successBlock failure:(BoardsFailure)failureBlock
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	NSString *urlAsString = [NSString stringWithFormat:@"%@%@", kBaseURL, kUsersForBoard];
	
	NSDictionary *parameters = @{@"id" : [board boardID],
								 @"token" : [user token]};
	
	[manager POST:urlAsString parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *usersForBoardDictionary) {
		
		NSArray *users = usersForBoardDictionary[@"users"];
		
		NSMutableArray *usersForBoard = [@[] mutableCopy];
		
		[users enumerateObjectsUsingBlock:^(NSDictionary *userDictionary, NSUInteger idx, BOOL *stop) {
			User *newUser = [User createOrUpdateUserWithID:userDictionary[@"id"]
													 email:userDictionary[@"email"]
												 firstName:userDictionary[@"first_name"]
												   surname:userDictionary[@"surname"]];
			
			[usersForBoard addObject:newUser];
		}];

		if(successBlock)
		{
			successBlock(usersForBoard);
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		if(failureBlock)
		{
			failureBlock(error);
		}
	}];
}

+ (void)inviteUserWithEmailAddress:(NSString *)emailAddress toBoard:(Board *)board forUser:(User *)user success:(InviteUserSuccess)successBlock failure:(BoardsFailure)failureBlock
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	NSString *urlAsString = [NSString stringWithFormat:@"%@%@", kBaseURL, kInviteUserToBoard];
	
	NSDictionary *parameters = @{@"email" : emailAddress,
								 @"boardID" : [board boardID],
								 @"token" : [user token]};
	
	[manager POST:urlAsString parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *invitedUserToBoardDictionary) {
		
		if(successBlock)
		{
			successBlock();
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		NSString *errorMessage = [operation responseObject][@"message"];
		
		if(errorMessage)
		{
			error = [NSError errorWithDomain:@"stickyNotes"
										code:[[operation response] statusCode]
									userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
		}
		
		if(failureBlock)
		{
			failureBlock(error);
		}
	}];
}

+ (void)deleteInvalidBoards
{
	[[Board whereWithFormat:@"hasBeenUploaded == NO"] enumerateObjectsUsingBlock:^(Board *board, NSUInteger idx, BOOL *stop) {
		[board delete];
	}];
}

@end
