//----------------------------------------------------------------------------------------------------------------------
//	NSComboBox+C++.mm			©2024 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "NSComboBox+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSComboBox extension

@implementation NSComboBox (Cpp)

// MARK: Class methods

//----------------------------------------------------------------------------------------------------------------------
+ (instancetype) createWithPlaceholderString:(const CString&) string
{
	// Create
	NSComboBox*	comboBox = [[NSComboBox alloc] initWithFrame:NSZeroRect];

	// Set placeholder
	comboBox.placeholderString = [(__bridge NSString*) string.getOSString() copy];

	return comboBox;
}

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (void) addString:(const CString&) string
{
	// Add item
	[self addItemWithObjectValue:(__bridge NSString*) string.getOSString()];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) addStrings:(const TArray<CString>&) strings
{
	// Iterate strings
	for (TArray<CString>::Iterator iterator = strings.getIterator(); iterator; iterator++)
		// Add string
		[self addItemWithObjectValue:(__bridge NSString*) iterator->getOSString()];
}

@end
