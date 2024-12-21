//----------------------------------------------------------------------------------------------------------------------
//	NSButton+C++.h			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "CString.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSButton extension

@interface NSButton (Cpp)

// MARK: Instance methods

- (void) setTitleString:(const CString&) string;

@end

NS_ASSUME_NONNULL_END
