//----------------------------------------------------------------------------------------------------------------------
//	NSPathControl+C++.h			©2023 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "CFolder.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSPathControl extension

@interface NSPathControl (Cpp)

// MARK: Properties

@property (nonatomic, assign) CFolder	cFolder;

@end

NS_ASSUME_NONNULL_END
