//
//  User.h
//  Sticky Notes
//
//  Created by Ste Prescott on 07/12/2013.
//  Copyright (c) 2013 ste.me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSSet *notes;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;

@end
