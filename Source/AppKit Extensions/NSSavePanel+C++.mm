//----------------------------------------------------------------------------------------------------------------------
//	NSSavePanel+C++.mm			©2026 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "NSSavePanel+C++.h"

#import "NSString+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSSavePanel extension

@implementation NSSavePanel (Cpp)

// MARK: Properties

//----------------------------------------------------------------------------------------------------------------------
- (CString) nameFieldString
{
	return CString((__bridge CFStringRef) self.nameFieldStringValue);
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setNameFieldString:(CString) string
{
	self.nameFieldStringValue = (__bridge NSString*) string.getOSString();
}

@end
