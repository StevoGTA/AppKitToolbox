//
//  NSPopUpButton+C++.mm
//  AppKit Toolbox
//
//  Created by Stevo on 5/12/23.
//

#import "NSPopUpButton+C++.h"

#import "NSMenuItem+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSPopUpButton extension

@implementation NSPopUpButton (Cpp)

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (void) addItemWithString:(const CString&) string
{
	// Add item
	[self addItemWithTitle:(__bridge NSString*) string.getOSString()];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) addItemWithString:(const CString&) string representedObject:(id) representedObject
{
	// Add item
	[self addItemWithTitle:(__bridge NSString*) string.getOSString()];
	self.lastItem.representedObject = representedObject;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) addItemWithString:(const CString&) string tag:(NSInteger) tag representedObject:(id) representedObject
		indentationLevel:(NSInteger) indentationLevel
{
	// Add item
	[self addItemWithTitle:(__bridge NSString*) string.getOSString()];
	self.lastItem.tag = tag;
	self.lastItem.representedObject = representedObject;
	self.lastItem.indentationLevel = indentationLevel;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) addItemWithString:(const CString&) string tag:(NSInteger) tag representedObject:(id) representedObject
{
	// Add item
	[self addItemWithTitle:(__bridge NSString*) string.getOSString()];
	self.lastItem.tag = tag;
	self.lastItem.representedObject = representedObject;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) addItemWithString:(const CString&) string tag:(NSInteger) tag indentationLevel:(NSInteger) indentationLevel
{
	// Add item
	[self addItemWithTitle:(__bridge NSString*) string.getOSString()];
	self.lastItem.tag = tag;
	self.lastItem.indentationLevel = indentationLevel;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) addItemWithString:(const CString&) string tag:(NSInteger) tag
{
	// Add item
	[self addItemWithTitle:(__bridge NSString*) string.getOSString()];
	self.lastItem.tag = tag;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) addItemWithString:(const CString&) string target:(NSObject*) target action:(SEL) action
{
	// Add item
	[self addItemWithTitle:(__bridge NSString*) string.getOSString()];
	self.lastItem.target = target;
	self.lastItem.action = action;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) addSubmenu:(NSMenu*) submenu withString:(const CString&) string
{
	// Add submenu
	[self addItemWithTitle:(__bridge NSString*) string.getOSString()];
	self.lastItem.submenu = submenu;
}

@end
