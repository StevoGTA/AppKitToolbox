//----------------------------------------------------------------------------------------------------------------------
//	NSTextView+C++.h			©2025 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "CString.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSTextView extension

@interface NSTextView (Cpp)

// MARK: Properties

@property (nonatomic, assign) CString	stringContent;

@end

NS_ASSUME_NONNULL_END
