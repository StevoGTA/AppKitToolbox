//
//  NSMenu+C++.mm
//  AppKit Toolbox
//
//  Created by Stevo on 5/12/23.
//

#import "NSMenu+C++.h"

#import "NSString+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSMenu extension

@implementation NSMenu (Cpp)

// MARK: Instance methods

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

@end
