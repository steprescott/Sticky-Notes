//
//  NSAttributedString+Addtions.h
//  Sticky Notes
//
//  Created by Ste Prescott on 23/03/2014.
//  Copyright (c) 2014 ste.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Addtions)

- (NSString *)asHTML;
+ (NSAttributedString *)fromHTML:(NSString *)html;

@end
