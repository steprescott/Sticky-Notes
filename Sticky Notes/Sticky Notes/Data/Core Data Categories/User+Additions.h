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

+ (User *)activeUser;
+ (void)loginUserWithUsername:(NSString *)username password:(NSString *)password success:(LoginSuccess)successBlock failure:(LoginFailure)failureBlock;
@end
