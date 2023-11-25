//----------------------------------------------------------------------------------------------------------------------
//	NSViewController+C++.h			©2021 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "CProgress.h"
#import "Swift.h"

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSViewController extension

@interface NSViewController (Cpp)

// MARK: Types


typedef	void*	_Nullable	(^ProgressProc)(__unsafe_unretained NSViewController* viewController,
									const I<CProgress>& progress);
typedef	void				(^ProgressCancelProc)(__unsafe_unretained NSViewController* viewController);
typedef	void				(^ProgressCompletionProc)(__unsafe_unretained NSViewController* viewController,
									void* result);

// MARK: Instance methods


- (void) performWithProgressViewController:(AKTProgressViewController*) progressViewController
		progress:(const I<CProgress>&) progress procDispatchQueue:(dispatch_queue_t) procDispatchQueue
		proc:(ProgressProc) proc cancelProc:(ProgressCancelProc) cancelProc
		completionProc:(ProgressCompletionProc) completionProc;
- (void) performWithProgressViewController:(AKTProgressViewController*) progressViewController
		progress:(const I<CProgress>&) progress proc:(ProgressProc) proc cancelProc:(ProgressCancelProc) cancelProc
		completionProc:(ProgressCompletionProc) completionProc;

@end

NS_ASSUME_NONNULL_END
