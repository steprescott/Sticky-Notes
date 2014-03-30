//
//  Note.h
//  Sticky Notes
//
//  Created by Ste Prescott on 25/03/2014.
//  Copyright (c) 2014 ste.me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Board, User;

@interface Note : NSManagedObject

@property (nonatomic, retain) NSNumber * authorID;
@property (nonatomic, retain) NSNumber * hasBeenUploaded;
@property (nonatomic, retain) id noteBody;
@property (nonatomic, retain) NSDate * noteDate;
@property (nonatomic, retain) NSNumber * noteID;
@property (nonatomic, retain) NSString * noteTitle;
@property (nonatomic, retain) User *author;
@property (nonatomic, retain) NSSet *boards;
@end

@interface Note (CoreDataGeneratedAccessors)

- (void)addBoardsObject:(Board *)value;
- (void)removeBoardsObject:(Board *)value;
- (void)addBoards:(NSSet *)values;
- (void)removeBoards:(NSSet *)values;

@end
