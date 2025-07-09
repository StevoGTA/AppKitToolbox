//----------------------------------------------------------------------------------------------------------------------
//	AKTTextCalendarDatePickerHelper+C++.h			©2025 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#include "TimeAndDate.h"

#import <AppKit/AppKit.h>

#import "Swift.h"

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTextCalendarDatePickerHelper extension

@interface AKTTextCalendarDatePickerHelper (Cpp)

// MARK: Properties

@property (nonatomic, assign)	SGregorianDate	gregorianDate;

@end

NS_ASSUME_NONNULL_END
