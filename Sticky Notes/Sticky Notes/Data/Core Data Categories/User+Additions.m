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

- (NSString *)fullName
{
	return [NSString stringWithFormat:@"%@ %@", self.firstName, self.surname];
}

+ (User *)activeUser
{
    return [[User where:@"isActive == YES"] lastObject];
}

+ (User *)userWithID:(NSNumber *)userID
{
	return [[User whereWithFormat:@"userID == %d", [userID integerValue]] lastObject];
}

+ (User *)createOrUpdateUserWithID:(NSNumber *)userID email:(NSString *)email firstName:(NSString *)firstName surname:(NSString *)surname
{
	User *newUser = [self userWithID:userID];
	
    if(!newUser)
    {
        newUser = [User create];
		
		if(newUser)
		{
        	[newUser setUserID:userID];
		}
		else
		{
			[newUser setUserID:[NSNumber numberWithLong:(([[User all] count] + 1)) * -1]];
		}
    }
	
	if(email && email != [NSNull null])
	{
		[newUser setEmail:email];
	}
    
	if(firstName && firstName != [NSNull null])
	{
    	[newUser setFirstName:firstName];
	}
	
	if(surname && surname != [NSNull null])
	{
		[newUser setSurname:surname];
	}
    
    return [newUser save] ? newUser : nil;
}

+ (void)loginUserWithUsername:(NSString *)username password:(NSString *)password success:(LoginSuccess)successBlock failure:(LoginFailure)failureBlock
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	NSString *urlAsString = [NSString stringWithFormat:@"%@%@", kBaseURL, kLogin];
	
	NSDictionary *parameters = @{@"username" : username,
								 @"password" : password};
	
	[manager POST:urlAsString parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *response) {
		
		[User logout];
		
		NSString *sessionToken = response[@"session"][@"id"];
		NSNumber *userID = response[@"user"][@"id"];
		NSString *email = response[@"user"][@"email"];
		NSString *firstName = response[@"user"][@"first_name"];
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
		[activeUser setToken:sessionToken];
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

+ (void)registerUserWithFirstname:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email password:(NSString *)password success:(LoginSuccess)successBlock failure:(LoginFailure)failureBlock
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	NSString *urlAsString = [NSString stringWithFormat:@"%@%@", kBaseURL, kRegister];
	
	NSDictionary *parameters = @{@"firstName" : firstName,
								 @"surname" : lastName,
								 @"email" : email,
								 @"password" : password};
	
	[manager POST:urlAsString parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *response) {
		
		[[User all] makeObjectsPerformSelector:@selector(setIsActive:) withObject:[NSNumber numberWithBool:NO]];
		
		NSLog(@"%@", response);
		
		NSNumber *userID = response[@"id"];
		NSString *email = response[@"email"];
		NSString *firstName = response[@"first_name"];
		NSString *surname = response[@"surname"];

		User *newUser = [User userWithID:userID];
		
		if(!newUser)
		{
			newUser = [User create];
		}
		
		[newUser setUserID:userID];
		[newUser setEmail:email];
		[newUser setFirstName:firstName];
		[newUser setSurname:surname];
		[newUser save];
		
		if(successBlock)
		{
			successBlock(newUser);
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		if(failureBlock)
		{
			NSString *errorMessage = [operation responseObject][@"message"];
			
			if(errorMessage)
			{
				error = [NSError errorWithDomain:@"stickyNotes"
											code:[[operation response] statusCode]
										userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
			}
			
			failureBlock(error);
		}
	}];
}

+ (void)updateUser:(User *)user withFirstname:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email success:(LoginSuccess)successBlock failure:(LoginFailure)failureBlock
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	NSString *urlAsString = [NSString stringWithFormat:@"%@%@", kBaseURL, kUpdateUser];
	
	NSDictionary *parameters = @{@"token" : [user token],
								 @"firstName" : firstName,
								 @"surname" : lastName,
								 @"email" : email};
	
	[manager POST:urlAsString parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *response) {
		
		[user setEmail:email];
		[user setFirstName:firstName];
		[user setSurname:lastName];
		[user save];
		
		if(successBlock)
		{
			successBlock(user);
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		if(failureBlock)
		{
			NSString *errorMessage = [operation responseObject][@"message"];
			
			if(errorMessage)
			{
				error = [NSError errorWithDomain:@"stickyNotes"
											code:[[operation response] statusCode]
										userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
			}
			
			failureBlock(error);
		}
	}];
}

+ (void)logout
{
	[[User all] makeObjectsPerformSelector:@selector(setIsActive:) withObject:[NSNumber numberWithBool:NO]];
	[User save];
}

- (void)logout
{
	[self setIsActive:[NSNumber numberWithBool:NO]];
	[self save];
}

@end
