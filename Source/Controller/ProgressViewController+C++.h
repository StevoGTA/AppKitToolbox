//----------------------------------------------------------------------------------------------------------------------
//	ProgressViewController+C++.h			©2021 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "CProgress.h"
#import "Swift.h"

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: ProgressViewController extension

@interface ProgressViewController (Cpp)

// MARK: Properties

@property (nonatomic, readonly)	CProgress::UpdateInfo	progressUpdateInfo;

@end

NS_ASSUME_NONNULL_END
