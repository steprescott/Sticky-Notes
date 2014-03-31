//
//  User+Additions.m
//  Sticky Notes
//
//  Created by Ste Prescott on 31/03/2014.
//  Copyright (c) 2014 ste.me. All rights reserved.
//

#import <XCTest/XCTest.h>

#import	"User+Additions.h"
#import "SKCoreDataManager.h"

@interface UserTests : XCTestCase

@property (nonatomic, strong) User *userObject;

@end

@implementation UserTests

- (void)setUp
{
    [super setUp];

	self.userObject = [User createOrUpdateUserWithID:@1
											   email:@"email"
										   firstName:@"firstName"
											 surname:@"surname"];
	
	[_userObject setIsActive:[NSNumber numberWithBool:YES]];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testCreationOfUser
{
	NSNumber *userID = @1;
	NSString *email = @"test@user.com";
	NSString *firstName = @"Test";
	NSString *surname = @"User";
	
	User *testUser = [User createOrUpdateUserWithID:userID
											  email:email
										  firstName:firstName
											surname:surname];
	
	XCTAssertNotNil(testUser, @"");
	XCTAssertEqualObjects([testUser userID], userID, @"");
	XCTAssertTrue([[testUser email] isEqualToString:email], @"");
	XCTAssertTrue([[testUser firstName] isEqualToString:firstName], @"");
	XCTAssertTrue([[testUser surname] isEqualToString:surname], @"");
}

- (void)testRetrievalOfUser
{
	User *retrivedUser = [User userWithID:@1];
	
	XCTAssertEqualObjects(_userObject, retrivedUser, @"");
}

- (void)testRetrievalOfActiveUser
{
	User *testActiveUser = [User activeUser];
	
	XCTAssertEqualObjects([_userObject userID], [testActiveUser userID], @"");
}

- (void)testDeletionOfUser
{
	User *retreivedUser = [User userWithID:@1];
	
	XCTAssertEqualObjects(_userObject, retreivedUser, @"");
	
	[_userObject delete];
	
	User *testUserHasBeenDeleted = [User userWithID:@1];
	
	XCTAssertNil(testUserHasBeenDeleted, @"");
}

- (void)testLogOutOfActiveUser
{
	User *activeUser = [User activeUser];
	XCTAssertNotNil(activeUser, @"");
	
	[activeUser logout];
	
	User *testLoggedOutUser = [User activeUser];
	XCTAssertNil(testLoggedOutUser, @"");
}

@end
