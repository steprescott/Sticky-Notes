//
//  NSAttributedString+Addtions.m
//  Sticky Notes
//
//  Created by Ste Prescott on 23/03/2014.
//  Copyright (c) 2014 ste.me. All rights reserved.
//

#import "NSAttributedString+Addtions.h"

@implementation NSAttributedString (Addtions)

- (NSString *)asHTML
{
	NSDictionary *documentAttributes = [NSDictionary dictionaryWithObjectsAndKeys:NSHTMLTextDocumentType, NSDocumentTypeDocumentAttribute, nil];
	NSData *htmlData = [self dataFromRange:NSMakeRange(0, self.length) documentAttributes:documentAttributes error:NULL];
	return [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
}

+ (NSAttributedString *)fromHTML:(NSString *)html
{
	NSAttributedString *string = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding]
																  options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
																			NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
																			}
																			documentAttributes:nil
																			error:nil];
	//iOS 7 bug where the font size is modified when saved to HTML
	NSMutableAttributedString *modifiedString = [string mutableCopy];
	[modifiedString beginEditing];
	[modifiedString enumerateAttribute:NSFontAttributeName
							   inRange:NSMakeRange(0, modifiedString.length)
							   options:0
							usingBlock:^(id value, NSRange range, BOOL *stop) {
								if (value)
								{
									UIFont *oldFont = (UIFont *)value;
									UIFont *newFont;
									
									if(oldFont.pointSize == 19 || oldFont.pointSize == 14)
									{
										newFont = [oldFont fontWithSize:14];
									}
									else
									{
										newFont = [oldFont fontWithSize:oldFont.pointSize - 4.0f];
									}
									
									[modifiedString addAttribute:NSFontAttributeName value:newFont range:range];
								 }
							 }];
	
	[modifiedString endEditing];
	
	return modifiedString;
}

@end
