//
//  Note.h
//  Sticky Notes
//
//  Created by Ste Prescott on 07/12/2013.
//  Copyright (c) 2013 ste.me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * noteTitle;
@property (nonatomic, retain) NSString * noteBody;
@property (nonatomic, retain) NSDate * noteDate;
@property (nonatomic, retain) NSString * noteID;
@property (nonatomic, retain) User *user;

@end
