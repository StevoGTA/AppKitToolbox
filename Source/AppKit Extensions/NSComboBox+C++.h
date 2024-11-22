//----------------------------------------------------------------------------------------------------------------------
//	NSComboBox+C++.h			©2024 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "CString.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSComboBox extension

@interface NSComboBox (Cpp)

// MARK: Instance methods

- (void) addString:(const CString&) string;

@end

NS_ASSUME_NONNULL_END
