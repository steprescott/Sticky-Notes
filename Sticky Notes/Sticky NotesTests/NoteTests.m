//
//  NoteTests.m
//  Sticky Notes
//
//  Created by Ste Prescott on 31/03/2014.
//  Copyright (c) 2014 ste.me. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CoreDataCategories.h"
#import "SKCoreDataManager.h"

@interface NoteTests : XCTestCase

@property (nonatomic, strong) Note *testObject;
@property (nonatomic, strong) User *testObjectUser;
@property (nonatomic, strong) Board *testObjectBoard;
@property (nonatomic, strong) NSDate *testObjectDate;

@end

@implementation NoteTests

- (void)setUp
{
    [super setUp];
	
	self.testObjectUser = [User createOrUpdateUserWithID:@1
												   email:@"email"
											   firstName:@"firstName"
												 surname:@"surname"];
	
	self.testObjectBoard = [Board createOrUpdateBoardWithID:@1
												  boardName:@"boardName"
										   boardOwnerUserID:[_testObjectUser userID]];
	
	self.testObjectDate = [NSDate new];
	
	self.testObject = [Note createOrUpdateNoteWithID:@1
											   title:@"Title"
												body:[[NSAttributedString alloc] initWithString:@"body"]
											noteDate:_testObjectDate
											authorID:@1
											 boardID:[_testObjectBoard boardID]];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testCreationOfNote
{
	Note *testNote = [Note createOrUpdateNoteWithID:@1
											  title:@"Title"
											   body:[[NSAttributedString alloc] initWithString:@"body"]
										   noteDate:_testObjectDate
										   authorID:@1
											boardID:[_testObjectBoard boardID]];
	
	XCTAssertNotNil(testNote, @"");
	XCTAssertEqualObjects([testNote noteID], @1, @"");
	XCTAssertTrue([[testNote noteTitle] isEqualToString:@"Title"], @"");
	XCTAssertTrue([[[testNote noteBody] string] isEqualToString:@"body"], @"");
	XCTAssertEqualObjects([testNote noteDate], _testObjectDate, @"");
	XCTAssertEqualObjects([testNote authorID], @1, @"");
	XCTAssertTrue([[testNote boards] containsObject:_testObjectBoard], @"");
}

- (void)testRetrievalOfNoteWithID
{
	Note *testNote = [Note noteWithNoteID:@1];
	XCTAssertNotNil(testNote, @"");
}

- (void)testRetrievalOfNoteForBoard
{
	XCTAssertTrue([[[_testObjectBoard notes] allObjects] containsObject:_testObject], @"");
}

- (void)testDeletionOfNote
{
	[_testObject delete];
	Note *testNote = [Note noteWithNoteID:@1];
	XCTAssertNil(testNote, @"");
}

@end
