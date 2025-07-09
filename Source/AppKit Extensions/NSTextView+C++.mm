//----------------------------------------------------------------------------------------------------------------------
//	NSTextView+C++.mm			©2025 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "NSTextView+C++.h"

#import "NSString+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSTextView extension

@implementation NSTextView (Cpp)

// MARK: Properties

//----------------------------------------------------------------------------------------------------------------------
- (CString) stringContent
{
	return CString((__bridge CFStringRef) self.textStorage.string);
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setStringContent:(CString) string
{
	[self setString:[(__bridge NSString*) string.getOSString() copy]];
}

@end
