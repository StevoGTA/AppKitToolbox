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

@end

NS_ASSUME_NONNULL_END
