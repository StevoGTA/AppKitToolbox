//----------------------------------------------------------------------------------------------------------------------
//	NSMenu+C++.mm			©2023 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "NSMenu+C++.h"

#import "NSString+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSMenu extension

@implementation NSMenu (Cpp)

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (void) addItemWithString:(const CString&) string target:(NSObject*) target action:(SEL) action
		tag:(NSInteger) tag representedObject:(NSObject*) representedObject
{
	// Setup
	NSMenuItem*	menuItem =
						[[NSMenuItem alloc] initWithTitle:(__bridge NSString*) string.getOSString() action:action
								keyEquivalent:@""];
	menuItem.target = target;
	menuItem.tag = tag;
	menuItem.representedObject = representedObject;

	// Add item
	[self addItem:menuItem];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) addItemWithString:(const CString&) string target:(NSObject*) target action:(SEL) action
		representedObject:(NSObject*) representedObject
{
	// Setup
	NSMenuItem*	menuItem =
						[[NSMenuItem alloc] initWithTitle:(__bridge NSString*) string.getOSString() action:action
								keyEquivalent:@""];
	menuItem.target = target;
	menuItem.representedObject = representedObject;

	// Add item
	[self addItem:menuItem];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) addItemWithString:(const CString&) string menu:(NSMenu*) menu
{
	// Setup
	NSMenuItem*	menuItem =
						[[NSMenuItem alloc] initWithTitle:(__bridge NSString*) string.getOSString() action:nil
								keyEquivalent:@""];
	menuItem.submenu = menu;

	// Add item
	[self addItem:menuItem];
}

@end
