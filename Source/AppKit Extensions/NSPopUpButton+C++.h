//
//  NSPopUpButton+C++.h
//  AppKit Toolbox
//
//  Created by Stevo on 5/12/23.
//

#include "CString.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSPopUpButton extension

@interface NSPopUpButton (Cpp)

// MARK: Instance methods

- (void) addItemWithString:(const CString&) string;
- (void) addItemWithString:(const CString&) string representedObject:(id) representedObject;
- (void) addItemWithString:(const CString&) string tag:(NSInteger) tag;
- (void) addItemWithString:(const CString&) string target:(NSObject*) target action:(SEL) action;

- (void) addSubmenu:(NSMenu*) submenu withString:(const CString&) string;

@end

NS_ASSUME_NONNULL_END
