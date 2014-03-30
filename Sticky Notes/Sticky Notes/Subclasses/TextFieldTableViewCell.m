
//*******
//
//	filename: TextFieldTableViewCell.m
//	author: Zack Brown
//	date: 04/06/2013
//
//*******
//

#import "TextFieldTableViewCell.h"

@interface TextFieldTableViewCell ()

@property (nonatomic, readwrite) UITextField *textField;

@end

@implementation TextFieldTableViewCell

#pragma mark - UITableViewCell methods

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    //call parent implementation
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

	if(self)
	{
		[self setTextField:[[UITextField alloc] initWithFrame:CGRectZero]];

		[[self textField] setReturnKeyType:UIReturnKeyDone];
        [[self textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
		[[self contentView] addSubview:[self textField]];
	}

	//bail
	return self;
}

- (void)layoutSubviews
{
	//call parent implementation
	[super layoutSubviews];

	CGSize size = [@"placeholder" sizeWithFont:[[self textField] font] constrainedToSize:self.contentView.bounds.size];

	[[self textField] setFrame:CGRectMake(self.textLabel.frame.size.width + 10.0, 0.0, (self.contentView.bounds.size.width - self.textLabel.frame.size.width - 20.0), size.height)];
	[[self textField] setCenter:CGPointMake(self.textField.center.x, self.contentView.center.y)];
}

@end