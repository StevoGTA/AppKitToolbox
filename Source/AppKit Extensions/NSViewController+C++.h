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
		progress:(const I<CProgress>&) progress
		proc:
				(void* _Nullable (^)(__unsafe_unretained NSViewController* viewController,
						const I<CProgress>& progress)) proc
		cancelProc:(void (^)(__unsafe_unretained NSViewController* viewController)) cancelProc
		completionProc:
				(void (^)(__unsafe_unretained NSViewController* viewController, void* result, BOOL wasCancelled))
						completionProc;
- (void) performWithProgressViewController:(AKTProgressViewController*) progressViewController
		progress:(const I<CProgress>&) progress
		proc:(void (^)(__unsafe_unretained NSViewController* viewController, const I<CProgress>& progress)) proc
		cancelProc:(void (^)(__unsafe_unretained NSViewController* viewController)) cancelProc
		completionProc:
				(void (^)(__unsafe_unretained NSViewController* viewController, BOOL wasCancelled)) completionProc;
- (void) performWithProgressViewController:(AKTProgressViewController*) progressViewController
		progress:(const I<CProgress>&) progress
		proc:(void (^)(__unsafe_unretained NSViewController* viewController, const I<CProgress>& progress)) proc
		cancelProc:(void (^)(__unsafe_unretained NSViewController* viewController)) cancelProc;

- (void) registerNotificationObserverForNotificationCenterAndName:
				(const SNotificationCenterAndName&) notificationCenterAndName
		proc:(NSViewControllerNotificationProc) proc;
- (void) registerNotificationObserverForNotificationCenter:(CNotificationCenter&) notificationCenter
		notificationName:(const CString&) notificationName sender:(const CNotificationCenter::Sender&) sender
		proc:(NSViewControllerNotificationProc) proc;
- (void) registerNotificationObserverForNotificationCenter:(CNotificationCenter&) notificationCenter
		notificationName:(const CString&) notificationName proc:(NSViewControllerNotificationProc) proc;

@end

NS_ASSUME_NONNULL_END
