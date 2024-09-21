//----------------------------------------------------------------------------------------------------------------------
//	NSDatePicker+C++.h			©2024 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#include "TimeAndDate.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSDatePicker extension

@interface NSDatePicker (Cpp)

// MARK: Properties

@property (nonatomic)	SGregorianDate	gregorianDate;

// MARK: Class methods

//+ (NSColor*) colorForCColor:(const CColor&) color;

@end

NS_ASSUME_NONNULL_END
