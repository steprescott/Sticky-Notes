//
//  BoardTests.m
//  Sticky Notes
//
//  Created by Ste Prescott on 31/03/2014.
//  Copyright (c) 2014 ste.me. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CoreDataCategories.h"
#import "SKCoreDataManager.h"

@interface BoardTests : XCTestCase

@property (nonatomic, strong) Board *testObject;

@end

@implementation BoardTests

- (void)setUp
{
    [super setUp];
	
	self.testObject = [Board createOrUpdateBoardWithID:@1
											 boardName:@"boardName"
									  boardOwnerUserID:@1];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testCreationOfBoard
{
	Board *testBoard = [Board createOrUpdateBoardWithID:@1
											  boardName:@"boardName"
									   boardOwnerUserID:@1];
	
	XCTAssertNotNil(testBoard, @"");
	XCTAssertEqualObjects([testBoard boardID], [_testObject boardID], @"");
	XCTAssertTrue([[testBoard boardName] isEqualToString:[_testObject boardName]], @"");
	XCTAssertEqualObjects([testBoard boardOwnerUserID], [_testObject boardOwnerUserID], @"");
}

- (void)testRetrievalOfBoardWithID
{
	Board *testBoard = [Board boardWithBoardID:@1];
	XCTAssertNotNil(testBoard, @"");
}

- (void)testDeletionOfBoard
{
	[_testObject delete];
	Board *testBoard = [Board boardWithBoardID:@1];
	XCTAssertNil(testBoard, @"");
}


@end
