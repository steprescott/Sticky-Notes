//
//  Board+Additions.h
//  Sticky Notes
//
//  Created by Ste Prescott on 18/02/2014.
//  Copyright (c) 2014 ste.me. All rights reserved.
//

#import "Board.h"

typedef void(^BoardsForUserSuccess)(NSDictionary *boards);
typedef void(^UploadBoardSuccess)(Board *board);
typedef void(^DeleteBoardSuccess)();
typedef void(^LeaveBoardSuccess)();
typedef void(^UsersForBoardSuccess)(NSArray *usersForBoard);
typedef void(^InviteUserSuccess)();

typedef void(^BoardsFailure)(NSError *error);

@class User;

@interface Board (Additions)

+ (Board *)boardWithBoardID:(NSNumber *)boardID;
+ (Board *)createOrUpdateBoardWithID:(NSNumber *)boardID boardName:(NSString *)boardName boardOwnerUserID:(NSNumber *)boardOwnerUserID;
+ (void)boardsForUser:(User *)user success:(BoardsForUserSuccess)successBlock failure:(BoardsFailure)failureBlock;
+ (void)uploadBoard:(Board *)board forUser:(User *)user success:(UploadBoardSuccess)successBlock failure:(BoardsFailure)failureBlock;
+ (void)deleteBoard:(Board *)board forUser:(User *)user success:(DeleteBoardSuccess)successBlock failure:(BoardsFailure)failureBlock;
+ (void)leaveBoard:(Board *)board forUser:(User *)user success:(LeaveBoardSuccess)successBlock failure:(BoardsFailure)failureBlock;
+ (void)usersForBoard:(Board *)board forUser:(User *)user success:(UsersForBoardSuccess)successBlock failure:(BoardsFailure)failureBlock;
+ (void)inviteUserWithEmailAddress:(NSString *)emailAddress toBoard:(Board *)board forUser:(User *)user success:(InviteUserSuccess)successBlock failure:(BoardsFailure)failureBlock;
+ (Board *)anyBoard;
+ (void)deleteInvalidBoards;
@end
