//----------------------------------------------------------------------------------------------------------------------
//	NSView+C++.h			©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "CString.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSView extension

@interface NSView (Cpp)

// MARK: Properties

@property (nonatomic, assign) CString	toolTipString;

@end

NS_ASSUME_NONNULL_END
