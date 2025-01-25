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

// MARK: Properties

//----------------------------------------------------------------------------------------------------------------------
- (SLocalization::Language) selectedLocalizationLanguage
{
	return *SLocalization::Language::getFor((OSType) self.selectedTag);
}

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
- (void) addDisabledItemWithString:(const CString&) string
{
	// Add item
	[self addItemWithTitle:(__bridge NSString*) string.getOSString()];
	self.lastItem.enabled = false;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) addSubmenu:(NSMenu*) submenu withString:(const CString&) string tag:(NSInteger) tag
{
	// Add submenu
	[self addItemWithTitle:(__bridge NSString*) string.getOSString()];
	self.lastItem.submenu = submenu;
	self.lastItem.tag = tag;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) addSubmenu:(NSMenu*) submenu withString:(const CString&) string
{
	// Add submenu
	[self addItemWithTitle:(__bridge NSString*) string.getOSString()];
	self.lastItem.submenu = submenu;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) selectItemWithString:(const CString&) string
{
	// Select item
	[self selectItemWithTitle:(__bridge NSString*) string.getOSString()];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setupWithLocalizationLanguages
{
	[self removeAllItems];
	for (TIteratorD<SLocalization::Language> iterator1 = SLocalization::Language::getAll().getIterator();
			iterator1.hasValue(); iterator1.advance()) {
		// Check if common
		if (iterator1->isCommon())
			// Found common
			[self addItemWithString:iterator1->getDisplayName() tag:iterator1->getISO639_2_Code()];
	}
	[self.menu addItem:NSMenuItem.separatorItem];
	for (TIteratorD<SLocalization::Language> iterator2 = SLocalization::Language::getAll().getIterator();
			iterator2.hasValue(); iterator2.advance()) {
		// Check if common
		if (!iterator2->isCommon())
			// Found not common
			[self addItemWithString:iterator2->getDisplayName() tag:iterator2->getISO639_2_Code()];
	}
}

//----------------------------------------------------------------------------------------------------------------------
- (void) selectedLocalizationLanguage:(const OV<SLocalization::Language>&) localizationLanguage
{
	// Check if have value
	if (localizationLanguage.hasValue())
		// All have the same value
		[self selectItemWithTag:localizationLanguage->getISO639_2_Code()];
	else
		// Start with first one
		[self selectItemAtIndex:0];
}

@end
