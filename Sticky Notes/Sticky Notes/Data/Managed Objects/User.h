//
//  User.h
//  Sticky Notes
//
//  Created by Ste Prescott on 25/03/2014.
//  Copyright (c) 2014 ste.me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Board;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSString * surname;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSSet *boards;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addBoardsObject:(Board *)value;
- (void)removeBoardsObject:(Board *)value;
- (void)addBoards:(NSSet *)values;
- (void)removeBoards:(NSSet *)values;

@end
