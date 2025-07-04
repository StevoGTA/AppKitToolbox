//----------------------------------------------------------------------------------------------------------------------
//	NSTextField+C++.h			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "CString.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSTextField extension

@interface NSTextField (Cpp)

// MARK: Properties

@property (nonatomic, assign) CString	string;

// MARK: Instance methods

- (void) setString:(const CString&) string animated:(BOOL) animated;

@end

NS_ASSUME_NONNULL_END
