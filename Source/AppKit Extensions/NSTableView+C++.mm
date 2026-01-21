//----------------------------------------------------------------------------------------------------------------------
//	NSTableView+C++.mm			©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "NSTableView+C++.h"

#import "NSString+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSTableView extension

@implementation NSTableView (Cpp)

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (nullable NSTableColumn*) tableColumnWithIdentifierString:(const CString&) string
{
	return [self tableColumnWithIdentifier:(__bridge NSString*) string.getOSString()];
}

@end
