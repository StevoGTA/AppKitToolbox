//----------------------------------------------------------------------------------------------------------------------
//	NSColor+C++.h			©2023 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#include "CColor.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSColor extension

@interface NSColor (Cpp)

// MARK: Properties

@property (nonatomic, readonly)	CColor	cColor;

// MARK: Class methods

+ (NSColor*) colorForCColor:(const CColor&) color;

@end

NS_ASSUME_NONNULL_END
