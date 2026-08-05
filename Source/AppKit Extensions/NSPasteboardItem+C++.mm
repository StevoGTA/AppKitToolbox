//----------------------------------------------------------------------------------------------------------------------
//	NSPasteboardItem+C++.mm			©2026 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "NSPasteboardItem+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSPasteboardItem extension

@implementation NSPasteboardItem (Cpp)

// MARK: Class methods

//----------------------------------------------------------------------------------------------------------------------
+ (instancetype) pasteboardItemWithString:(const CString&) string forType:(NSString*) type
{
	// Setup
	NSPasteboardItem*	pasteboardItem = [[NSPasteboardItem alloc] init];
	[pasteboardItem setString:(__bridge NSString*) string.getOSString() forType:type];

	return pasteboardItem;
}

@end
