//----------------------------------------------------------------------------------------------------------------------
//	AKTProgressViewController+C++.h			©2021 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "CProgress.h"

#import <AppKit/AppKit.h>

#import "Swift.h"

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTProgressViewController extension

@interface AKTProgressViewController (Cpp)

// MARK: Properties

@property (nonatomic, readonly)	CProgress::UpdateInfo	progressUpdateInfo;

@end

NS_ASSUME_NONNULL_END
