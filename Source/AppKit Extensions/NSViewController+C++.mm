//----------------------------------------------------------------------------------------------------------------------
//	NSViewController+C++.mm			©2021 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "NSViewController+C++.h"

#import "NSString+C++.h"
#import "AKTProgressViewController+C++.h"

#import <objc/runtime.h>

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSViewControllerNotificationObserverCleanup

@interface NSViewControllerNotificationObserverCleanup : NSObject {
	// MARK: Properties
	void*												mViewController;
	NSMutableArray<NSViewControllerNotificationProc>*	mNotificationProcs;
}

@end

@implementation NSViewControllerNotificationObserverCleanup

//----------------------------------------------------------------------------------------------------------------------
- (instancetype) initWithViewController:(NSViewController*) viewController
//----------------------------------------------------------------------------------------------------------------------
{
	if (self = [super init]) {
		// Store
		mViewController = (__bridge void*) viewController;
		mNotificationProcs = [NSMutableArray array];
	}

	return self;
}

//----------------------------------------------------------------------------------------------------------------------
- (void*) addNotificationProc:(NSViewControllerNotificationProc) notificationProc
//----------------------------------------------------------------------------------------------------------------------
{
	// The strong assignment triggers objc_retainBlock, which copies a stack block to the heap.
	// addObject: uses objc_retain (a no-op for stack blocks), so this step must not be skipped.
	// Blocks passed in are mostly likely stack blocks, so this is necessary to ensure they are retained properly.
	NSViewControllerNotificationProc	heapNotificationProc = notificationProc;
	[mNotificationProcs addObject:heapNotificationProc];

	return (__bridge void*) heapNotificationProc;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) dealloc
//----------------------------------------------------------------------------------------------------------------------
{
	// Unregister all observers for this VC
	CImmediateNotificationCenter::shared().unregisterObserver(mViewController);
}

@end

//----------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
// MARK: - Local procs

//----------------------------------------------------------------------------------------------------------------------
static void sHandleNotification(const CString& notificationName, const OR<CNotificationCenter::Sender>& sender,
		const CDictionary& info, void* userData)
//----------------------------------------------------------------------------------------------------------------------
{
	// Call proc
	((__bridge NSViewControllerNotificationProc) userData)(notificationName, sender, info);
}

//----------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
// MARK: - NSViewController extension

@implementation NSViewController (Cpp)

//----------------------------------------------------------------------------------------------------------------------
- (NSViewControllerNotificationObserverCleanup*) notificationObserverCleanup
//----------------------------------------------------------------------------------------------------------------------
{
	// Setup
	static	const	void*	sKey = &sKey;

	// Get or create cleanup object
	NSViewControllerNotificationObserverCleanup*	notificationObserverCleanup = objc_getAssociatedObject(self, sKey);
	if (notificationObserverCleanup == nil) {
		// Create
		notificationObserverCleanup = [[NSViewControllerNotificationObserverCleanup alloc] initWithViewController:self];

		// Associate
		objc_setAssociatedObject(self, sKey, notificationObserverCleanup, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}

	return notificationObserverCleanup;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) performWithResultProgressViewController:(AKTProgressViewController*) progressViewController
		progress:(const I<CProgress>&) progress procDispatchQueue:(dispatch_queue_t) procDispatchQueue
		proc:
				(void* _Nullable (^)(__unsafe_unretained NSViewController* viewController,
							const I<CProgress>& progress)) proc
		cancelProc:(void (^)(__unsafe_unretained NSViewController* viewController)) cancelProc
		completionProc:(void (^)(__unsafe_unretained NSViewController* viewController, void* result)) completionProc
{
	// Setup
	__block				BOOL			isCancelled = NO;
	__unsafe_unretained	typeof(self)	unsafeUnretainedSelf = self;
	progressViewController.cancelProc = ^{
		// Cancelled
		isCancelled = YES;

		// Call cancel proc
		cancelProc(unsafeUnretainedSelf);
	};

	// Present as sheet
	[self presentViewControllerAsSheet:progressViewController];

	// Perform on proc dispatch queue
	__block	I<CProgress>	progressUse(progress);
	dispatch_async(procDispatchQueue, ^{
		// Call proc
		void*	result = proc(unsafeUnretainedSelf, progressUse);

		// Jump to main queue
		dispatch_async(dispatch_get_main_queue(), ^{
			// Check if still presented.  It may have been previously dismissed and then not presented again.
			if (unsafeUnretainedSelf.presentedViewControllers.count > 0)
				// Dismiss
				[unsafeUnretainedSelf dismissViewController:progressViewController];

			// Check cancelled
			if (!isCancelled)
				// Call completion proc
				completionProc(unsafeUnretainedSelf, result);
		});
	});
}

//----------------------------------------------------------------------------------------------------------------------
- (void) performWithResultProgressViewController:(AKTProgressViewController*) progressViewController
		progress:(const I<CProgress>&) progress
		proc:
				(void* _Nullable (^)(__unsafe_unretained NSViewController* viewController,
						const I<CProgress>& progress)) proc
		cancelProc:(void (^)(__unsafe_unretained NSViewController* viewController)) cancelProc
		completionProc:(void (^)(__unsafe_unretained NSViewController* viewController, void* result)) completionProc
{
	// Perform
	[self performWithResultProgressViewController:progressViewController progress:progress
			procDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) proc:proc
			cancelProc:cancelProc completionProc:completionProc];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) performWithProgressViewController:(AKTProgressViewController*) progressViewController
		progress:(const I<CProgress>&) progress
		proc:(void (^)(__unsafe_unretained NSViewController* viewController, const I<CProgress>& progress)) proc
		cancelProc:(void (^)(__unsafe_unretained NSViewController* viewController)) cancelProc
		completionProc:(void (^)(__unsafe_unretained NSViewController* viewController)) completionProc
{
	// Perform
	[self performWithResultProgressViewController:progressViewController progress:progress
			procDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
			proc:^void*(NSViewController* viewController, const I<CProgress>& progress_){
				// Call proc
				proc(viewController, progress_);

				return nil;
			} cancelProc:cancelProc completionProc:^(NSViewController* viewController, void* result){
				// Call completion proc
				completionProc(viewController);
			}];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) registerNotificationObserverForName:(const CString&) notificationName
		sender:(const CNotificationCenter::Sender&) sender proc:(NSViewControllerNotificationProc) proc
{
	// Register
	CImmediateNotificationCenter::shared()
			.registerObserver(notificationName, sender,
					CNotificationCenter::Observer((__bridge void*) self, sHandleNotification,
							[self.notificationObserverCleanup addNotificationProc:proc]));
}

//----------------------------------------------------------------------------------------------------------------------
- (void) registerNotificationObserverForName:(const CString&) notificationName
		proc:(NSViewControllerNotificationProc) proc
{
	// Register
	CImmediateNotificationCenter::shared()
			.registerObserver(notificationName,
					CNotificationCenter::Observer((__bridge void*) self, sHandleNotification,
							[self.notificationObserverCleanup addNotificationProc:proc]));
}

@end
