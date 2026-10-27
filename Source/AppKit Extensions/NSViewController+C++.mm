//----------------------------------------------------------------------------------------------------------------------
//	NSViewController+C++.mm			©2021 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "NSViewController+C++.h"

#import "NSString+C++.h"
#import "AKTProgressViewController+C++.h"

#import <objc/runtime.h>

//----------------------------------------------------------------------------------------------------------------------
// MARK: Local proc declarations

static	void	sHandleNotification(const CString& notificationName, const OR<CNotificationCenter::Sender>& sender,
						const CDictionary& info, void* userData);

//----------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
// MARK: - NSViewControllerNotificationObserver

@interface NSViewControllerNotificationObserver : NSObject

// MARK: Properties

@property (nonatomic, assign)	CNotificationCenter*				notificationCenter;
@property (nonatomic, copy)		NSViewControllerNotificationProc	notificationProc;

@end

@implementation NSViewControllerNotificationObserver

//----------------------------------------------------------------------------------------------------------------------
- (instancetype) initWithNotificationCenter:(CNotificationCenter&) notificationCenter
		notificationName:(const CString&) notificationName
		sender:(const OR<const CNotificationCenter::Sender>&) sender
		notificationProc:(NSViewControllerNotificationProc) notificationProc
//----------------------------------------------------------------------------------------------------------------------
{
	if (self = [super init]) {
		// Store
		self.notificationCenter = &notificationCenter;
		self.notificationProc = notificationProc;

		// Register
		CNotificationCenter::Observer	observer((__bridge void*) self, sHandleNotification, (__bridge void*) self);
		if (sender.hasReference())
			// Have sender
			notificationCenter.registerObserver(notificationName, *sender, observer);
		else
			// Don't have sender
			notificationCenter.registerObserver(notificationName, observer);
	}

	return self;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) dealloc
//----------------------------------------------------------------------------------------------------------------------
{
	// Unregister
	self.notificationCenter->unregisterObserver((__bridge void*) self);
}

@end

//----------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
// MARK: - NSViewController extension

@implementation NSViewController (Cpp)

//----------------------------------------------------------------------------------------------------------------------
- (NSMutableArray<NSViewControllerNotificationObserver*>*) notificationObservers
//----------------------------------------------------------------------------------------------------------------------
{
	// Setup
	static	const	void*	sKey = &sKey;

	// Get or create notification observers
	NSMutableArray<NSViewControllerNotificationObserver*>*	notificationObservers =
																	objc_getAssociatedObject(self, sKey);
	if (notificationObservers == nil) {
		// Create
		notificationObservers = [NSMutableArray array];

		// Associate
		objc_setAssociatedObject(self, sKey, notificationObservers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}

	return notificationObservers;
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
- (void) registerNotificationObserverForNotificationCenterAndName:
				(const SNotificationCenterAndName&) notificationCenterAndName
		proc:(NSViewControllerNotificationProc) proc
{
	// Add notification observer
	[self.notificationObservers
			addObject:
					[[NSViewControllerNotificationObserver alloc]
							initWithNotificationCenter:notificationCenterAndName.getNotificationCenter()
							notificationName:notificationCenterAndName.getNotificationName()
							sender:OR<const CNotificationCenter::Sender>() notificationProc:proc]];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) registerNotificationObserverForNotificationCenter:(CNotificationCenter&) notificationCenter
		notificationName:(const CString&) notificationName sender:(const CNotificationCenter::Sender&) sender
		proc:(NSViewControllerNotificationProc) proc
{
	// Add notification observer
	[self.notificationObservers
			addObject:
					[[NSViewControllerNotificationObserver alloc] initWithNotificationCenter:notificationCenter
							notificationName:notificationName sender:OR<const CNotificationCenter::Sender>(sender)
							notificationProc:proc]];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) registerNotificationObserverForNotificationCenter:(CNotificationCenter&) notificationCenter
		notificationName:(const CString&) notificationName proc:(NSViewControllerNotificationProc) proc
{
	// Add notification observer
	[self.notificationObservers
			addObject:
					[[NSViewControllerNotificationObserver alloc] initWithNotificationCenter:notificationCenter
							notificationName:notificationName sender:OR<const CNotificationCenter::Sender>()
							notificationProc:proc]];
}

@end

//----------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
// MARK: - Local proc definitions

//----------------------------------------------------------------------------------------------------------------------
void sHandleNotification(const CString& notificationName, const OR<CNotificationCenter::Sender>& sender,
		const CDictionary& info, void* userData)
//----------------------------------------------------------------------------------------------------------------------
{
	// Call proc
	((__bridge NSViewControllerNotificationObserver*) userData).notificationProc(notificationName, sender, info);
}
