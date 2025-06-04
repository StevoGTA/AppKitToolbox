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

@property (nonatomic, assign)	SGregorianDate	gregorianDate;

@end

NS_ASSUME_NONNULL_END
