//
//  NSMenu+C++.h
//  AppKit Toolbox
//
//  Created by Stevo on 5/12/23.
//

#include "CString.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSMenu extension

@interface NSMenu (Cpp)

// MARK: Instance methods

- (void) addItemWithString:(const CString&) string target:(NSObject*) target action:(SEL) action
		tag:(NSInteger) tag representedObject:(NSObject*) representedObject;
- (void) addItemWithString:(const CString&) string target:(NSObject*) target action:(SEL) action
		representedObject:(NSObject*) representedObject;

@end

NS_ASSUME_NONNULL_END
