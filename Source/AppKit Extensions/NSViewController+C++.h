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

typedef	void	(^NSViewControllerNotificationProc)(const CString& notificationName,
						const OR<CNotificationCenter::Sender>& sender, const CDictionary& info);

//----------------------------------------------------------------------------------------------------------------------
// MARK: - NSViewController extension

@interface NSViewController (Cpp)

// MARK: Instance methods

- (void) performWithResultProgressViewController:(AKTProgressViewController*) progressViewController
		progress:(const I<CProgress>&) progress procDispatchQueue:(dispatch_queue_t) procDispatchQueue
		proc:
				(void* _Nullable (^)(__unsafe_unretained NSViewController* viewController,
							const I<CProgress>& progress)) proc
		cancelProc:(void (^)(__unsafe_unretained NSViewController* viewController)) cancelProc
		completionProc:(void (^)(__unsafe_unretained NSViewController* viewController, void* result)) completionProc;
- (void) performWithResultProgressViewController:(AKTProgressViewController*) progressViewController
		progress:(const I<CProgress>&) progress
		proc:
				(void* _Nullable (^)(__unsafe_unretained NSViewController* viewController,
						const I<CProgress>& progress)) proc
		cancelProc:(void (^)(__unsafe_unretained NSViewController* viewController)) cancelProc
		completionProc:(void (^)(__unsafe_unretained NSViewController* viewController, void* result)) completionProc;
- (void) performWithProgressViewController:(AKTProgressViewController*) progressViewController
		progress:(const I<CProgress>&) progress
		proc:(void (^)(__unsafe_unretained NSViewController* viewController, const I<CProgress>& progress)) proc
		cancelProc:(void (^)(__unsafe_unretained NSViewController* viewController)) cancelProc
		completionProc:(void (^)(__unsafe_unretained NSViewController* viewController)) completionProc;

- (void) registerNotificationObserverForName:(const CString&) notificationName
		sender:(const CNotificationCenter::Sender&) sender proc:(NSViewControllerNotificationProc) proc;
- (void) registerNotificationObserverForName:(const CString&) notificationName
		proc:(NSViewControllerNotificationProc) proc;

@end

NS_ASSUME_NONNULL_END
