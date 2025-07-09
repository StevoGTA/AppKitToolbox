//----------------------------------------------------------------------------------------------------------------------
//	NSPopUpButton+C++.h			©2023 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "SLocalization.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSPopUpButton extension

@interface NSPopUpButton (Cpp)

// MARK: Properties

@property (nonatomic, readonly)	SLocalization::Currency	selectedLocalizationCurrency;
@property (nonatomic, readonly)	SLocalization::Language	selectedLocalizationLanguage;

// MARK: Instance methods

- (void) addItemWithString:(const CString&) string;
- (void) addItemWithString:(const CString&) string representedObject:(id) representedObject;
- (void) addItemWithString:(const CString&) string tag:(NSInteger) tag representedObject:(id) representedObject
		indentationLevel:(NSInteger) indentationLevel;
- (void) addItemWithString:(const CString&) string tag:(NSInteger) tag representedObject:(id) representedObject;
- (void) addItemWithString:(const CString&) string tag:(NSInteger) tag indentationLevel:(NSInteger) indentationLevel;
- (void) addItemWithString:(const CString&) string tag:(NSInteger) tag;
- (void) addItemWithString:(const CString&) string target:(NSObject*) target action:(SEL) action;

- (void) addDisabledItemWithString:(const CString&) string;

- (void) addSubmenu:(NSMenu*) submenu withString:(const CString&) string tag:(NSInteger) tag;
- (void) addSubmenu:(NSMenu*) submenu withString:(const CString&) string;

- (void) selectItemWithString:(const CString&) string;

- (void) setupWithLocalizationCurrencies;
- (void) selectLocalizationCurrency:(const SLocalization::Currency&) localizationCurrency;

- (void) setupWithLocalizationLanguages;
- (void) selectLocalizationLanguage:(const OV<SLocalization::Language>&) localizationLanguage;

@end

NS_ASSUME_NONNULL_END
