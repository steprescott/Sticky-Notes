//
//  User+Additions.h
//  Sticky Notes
//
//  Created by Ste Prescott on 07/12/2013.
//  Copyright (c) 2013 ste.me. All rights reserved.
//

#import "User.h"

typedef void(^LoginSuccess)(User *activeUser);
typedef void(^LoginFailure)(NSError *error);

@interface User (Additions)

- (NSString *)fullName;

+ (User *)activeUser;
+ (User *)userWithID:(NSNumber *)userID;
+ (User *)createOrUpdateUserWithID:(NSNumber *)userID email:(NSString *)email firstName:(NSString *)firstName surname:(NSString *)surname;
+ (void)loginUserWithUsername:(NSString *)username password:(NSString *)password success:(LoginSuccess)successBlock failure:(LoginFailure)failureBlock;
+ (void)registerUserWithFirstname:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email password:(NSString *)password success:(LoginSuccess)successBlock failure:(LoginFailure)failureBlock;
+ (void)updateUser:(User *)user withFirstname:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email success:(LoginSuccess)successBlock failure:(LoginFailure)failureBlock;
+ (void)logout;
- (void)logout;
@end
