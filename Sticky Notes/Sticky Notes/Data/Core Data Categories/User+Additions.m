//
//  User+Additions.m
//  Sticky Notes
//
//  Created by Ste Prescott on 07/12/2013.
//  Copyright (c) 2013 ste.me. All rights reserved.
//

#import "User+Additions.h"
#import "SKCoreDataManager.h"

@implementation User (Additions)

+ (User *)activeUser
{
    return [[User where:@"isActive == YES"] lastObject];
}

@end
