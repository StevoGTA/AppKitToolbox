//
//  NSMenuItem+C++.h
//  AppKit Toolbox
//
//  Created by Stevo on 7/2/23.
//

#include "CString.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSMenuItem extension

@interface NSMenuItem (Cpp)

// MARK: Class methods

+ (instancetype) menuItemWithString:(const CString&) string target:(NSObject*) target action:(SEL) action
		tag:(NSInteger) tag representedObject:(NSObject*) representedObject;
+ (instancetype) menuItemWithString:(const CString&) string target:(NSObject*) target action:(SEL) action
		representedObject:(NSObject*) representedObject;
+ (instancetype) menuItemWithString:(const CString&) string tag:(NSInteger) tag
		representedObject:(NSObject*) representedObject;
+ (instancetype) menuItemWithString:(const CString&) string tag:(NSInteger) tag;
+ (instancetype) menuItemWithString:(const CString&) string representedObject:(NSObject*) representedObject;
+ (instancetype) menuItemWithString:(const CString&) string;

@end

NS_ASSUME_NONNULL_END
