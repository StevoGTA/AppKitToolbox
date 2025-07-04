//----------------------------------------------------------------------------------------------------------------------
//	NSTextField+C++.mm			©2021 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "NSTextField+C++.h"

#import "NSString+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSTextField extension

@implementation NSTextField (Cpp)

// MARK: Properties

//----------------------------------------------------------------------------------------------------------------------
- (CString) string
{
	return CString((__bridge CFStringRef) self.stringValue);
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setString:(CString) string
{
	self.stringValue = [(__bridge NSString*) string.getOSString() copy];
}

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (void) setString:(const CString&) string animated:(BOOL) animated
{
	// Check animated
	if (animated)
		// Animated
		self.animator.stringValue = [(__bridge NSString*) string.getOSString() copy];
	else
		// Update
		self.stringValue = [(__bridge NSString*) string.getOSString() copy];
}

@end
