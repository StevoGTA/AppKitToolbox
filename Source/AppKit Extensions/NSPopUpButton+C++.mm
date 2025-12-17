//----------------------------------------------------------------------------------------------------------------------
//	NSPopUpButton+C++.mm			©2023 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "NSPopUpButton+C++.h"

#import "NSMenuItem+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSPopUpButton extension

@implementation NSPopUpButton (Cpp)

// MARK: Properties

//----------------------------------------------------------------------------------------------------------------------
- (SLocalization::Currency) selectedLocalizationCurrency
{
	return *SLocalization::Currency::getFor(
			CString((CFStringRef) CFBridgingRetain(self.selectedItem.representedObject)));
}

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
- (void) setupWithLocalizationCurrencies
{
	// Setup
	[self removeAllItems];
	for (TIteratorD<SLocalization::Currency> iterator1 = SLocalization::Currency::getAll().getIterator();
			iterator1.hasValue(); iterator1.advance()) {
		// Check if common
		if (iterator1->isCommon())
			// Found common
			[self addItemWithString:iterator1->getCodeAndDisplayName()
					representedObject:(__bridge NSString*) iterator1->getISO4217Code().getOSString()];
	}
	[self.menu addItem:NSMenuItem.separatorItem];
	for (TIteratorD<SLocalization::Currency> iterator2 = SLocalization::Currency::getAll().getIterator();
			iterator2.hasValue(); iterator2.advance()) {
		// Check if common
		if (!iterator2->isCommon())
			// Found not common
			[self addItemWithString:iterator2->getCodeAndDisplayName()
					representedObject:(__bridge NSString*) iterator2->getISO4217Code().getOSString()];
	}
}

//----------------------------------------------------------------------------------------------------------------------
- (void) selectLocalizationCurrency:(const SLocalization::Currency&) localizationCurrency
{
	// Select item
	for (NSMenuItem* menuItem in self.itemArray) {
		// Get represented object
		id	representedObject = menuItem.representedObject;
		if ((representedObject != nil) &&
			[((NSString*) representedObject)
					isEqualToString:(__bridge NSString*) localizationCurrency.getISO4217Code().getOSString()]) {
			// Select this one
			[self selectItem:menuItem];

			return;
		}
	}
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setupWithLocalizationLanguages
{
	// Setup
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
- (void) selectLocalizationLanguage:(const OV<SLocalization::Language>&) localizationLanguage
{
#error Make this simpler, and also check call site to see if functionality is duplicated
	// Check if have value
	if (localizationLanguage.hasValue())
		// Select item
		[self selectItemWithTag:localizationLanguage->getISO639_2_Code()];
	else
		// Select first one
		[self selectItemAtIndex:0];
}

@end
