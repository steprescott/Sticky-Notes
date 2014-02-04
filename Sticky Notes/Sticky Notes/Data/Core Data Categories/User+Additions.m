//
//  User+Additions.m
//  Sticky Notes
//
//  Created by Ste Prescott on 07/12/2013.
//  Copyright (c) 2013 ste.me. All rights reserved.
//

#import "User+Additions.h"
#import "SKCoreDataManager.h"
#import "AFNetworking.h"
#import "Constants.h"

@implementation User (Additions)

+ (User *)activeUser
{
    return [[User where:@"isActive == YES"] lastObject];
}

+ (User *)userWithID:(NSString *)userID
{
	return [[User whereWithFormat:@"userID == '%@'", userID] lastObject];
}

+ (void)loginUserWithUsername:(NSString *)username password:(NSString *)password success:(LoginSuccess)successBlock failure:(LoginFailure)failureBlock
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	NSString *urlAsString = [NSString stringWithFormat:@"%@%@", kBaseURL, klogin];
	
	NSDictionary *parameters = @{@"username" : username,
								 @"password" : password};
	
	[manager POST:urlAsString parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *response) {
		
		[[User all] makeObjectsPerformSelector:@selector(setIsActive:) withObject:[NSNumber numberWithBool:NO]];
		
		NSString *userID = response[@"user"][@"email"];
		NSString *email = response[@"user"][@"email"];
		NSString *firstName = response[@"user"][@"firstName"];
		NSString *surname = response[@"user"][@"surname"];
		
		User *activeUser = [User userWithID:userID];
		
		if(!activeUser)
		{
			activeUser = [User create];
		}
		
		[activeUser setUserID:userID];
		[activeUser setEmail:email];
		[activeUser setFirstName:firstName];
		[activeUser setSurname:surname];
		[activeUser setIsActive:[NSNumber numberWithBool:YES]];
		[activeUser save];
		
		if(successBlock)
		{
			successBlock(activeUser);
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		if(failureBlock)
		{
			failureBlock(error);
		}
	}];
}

@end
