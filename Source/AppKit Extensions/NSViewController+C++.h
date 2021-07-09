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

typedef	void*	_Nullable	(^Proc)(__unsafe_unretained NSViewController* viewController);
typedef	void				(^CancelProc)();
typedef	void				(^CompletionProc)(void* result);

// MARK: Instance methods

- (void) performWithProgressViewController:(ProgressViewController*) progressViewController
		progress:(const CProgress&) progress procDispatchQueue:(dispatch_queue_t) procDispatchQueue proc:(Proc) proc
		cancelProc:(CancelProc) cancelProc completionProc:(CompletionProc) completionProc;
- (void) performWithProgressViewController:(ProgressViewController*) progressViewController
		progress:(const CProgress&) progress proc:(Proc) proc cancelProc:(CancelProc) cancelProc
		completionProc:(CompletionProc) completionProc;
- (void) performWithProgressViewController:(ProgressViewController*) progressViewController
		progress:(const CProgress&) progress procDispatchQueue:(dispatch_queue_t) procDispatchQueue proc:(Proc) proc
		completionProc:(CompletionProc) completionProc;
- (void) performWithProgressViewController:(ProgressViewController*) progressViewController
		progress:(const CProgress&) progress proc:(Proc) proc completionProc:(CompletionProc) completionProc;
- (void) performWithProgressViewController:(ProgressViewController*) progressViewController
		progress:(const CProgress&) progress procDispatchQueue:(dispatch_queue_t) procDispatchQueue proc:(Proc) proc
		cancelProc:(CancelProc) cancelProc;
- (void) performWithProgressViewController:(ProgressViewController*) progressViewController
		progress:(const CProgress&) progress proc:(Proc) proc cancelProc:(CancelProc) cancelProc;
- (void) performWithProgressViewController:(ProgressViewController*) progressViewController
		progress:(const CProgress&) progress procDispatchQueue:(dispatch_queue_t) procDispatchQueue proc:(Proc) proc;
- (void) performWithProgressViewController:(ProgressViewController*) progressViewController
		progress:(const CProgress&) progress proc:(Proc) proc;

@end

NS_ASSUME_NONNULL_END
