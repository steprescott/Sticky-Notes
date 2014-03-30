//
//  Board.h
//  Sticky Notes
//
//  Created by Ste Prescott on 25/03/2014.
//  Copyright (c) 2014 ste.me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note, User;

@interface Board : NSManagedObject

@property (nonatomic, retain) NSNumber * boardID;
@property (nonatomic, retain) NSString * boardName;
@property (nonatomic, retain) NSNumber * boardOwnerUserID;
@property (nonatomic, retain) NSNumber * hasBeenUploaded;
@property (nonatomic, retain) NSSet *notes;
@property (nonatomic, retain) NSSet *users;
@end

@interface Board (CoreDataGeneratedAccessors)

- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;

- (void)addUsersObject:(User *)value;
- (void)removeUsersObject:(User *)value;
- (void)addUsers:(NSSet *)values;
- (void)removeUsers:(NSSet *)values;

@end
