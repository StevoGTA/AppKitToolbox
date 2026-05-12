//----------------------------------------------------------------------------------------------------------------------
//	NSViewController+C++.h			©2021 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "CNotificationCenter.h"
#import "CProgress.h"

#import <AppKit/AppKit.h>

#import "Swift.h"

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: Types

typedef	void*	_Nullable	(^NSViewControllerProgressProc)(__unsafe_unretained NSViewController* viewController,
									const I<CProgress>& progress);
typedef	void				(^NSViewControllerProgressCancelProc)(__unsafe_unretained NSViewController* viewController);
typedef	void				(^NSViewControllerProgressCompletionProc)(
									__unsafe_unretained NSViewController* viewController, void* result);

typedef	void				(^NSViewControllerNotificationProc)(const CString& notificationName,
									const OR<CNotificationCenter::Sender>& sender, const CDictionary& info);


//----------------------------------------------------------------------------------------------------------------------
// MARK: - NSViewController extension

@interface NSViewController (Cpp)

// MARK: Instance methods

- (void) performWithProgressViewController:(AKTProgressViewController*) progressViewController
		progress:(const I<CProgress>&) progress procDispatchQueue:(dispatch_queue_t) procDispatchQueue
		proc:(NSViewControllerProgressProc) proc cancelProc:(NSViewControllerProgressCancelProc) cancelProc
		completionProc:(NSViewControllerProgressCompletionProc) completionProc;
- (void) performWithProgressViewController:(AKTProgressViewController*) progressViewController
		progress:(const I<CProgress>&) progress proc:(NSViewControllerProgressProc) proc
		cancelProc:(NSViewControllerProgressCancelProc) cancelProc
		completionProc:(NSViewControllerProgressCompletionProc) completionProc;

- (void) registerNotificationObserverForName:(const CString&) notificationName
		sender:(const CNotificationCenter::Sender&) sender proc:(NSViewControllerNotificationProc) proc;
- (void) registerNotificationObserverForName:(const CString&) notificationName
		proc:(NSViewControllerNotificationProc) proc;

@end

NS_ASSUME_NONNULL_END
