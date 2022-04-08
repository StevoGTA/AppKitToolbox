//----------------------------------------------------------------------------------------------------------------------
//	NSViewController+C++.mm			©2021 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "NSViewController+C++.h"

#import "ProgressViewController+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSViewController extension

@implementation NSViewController (Cpp)

//----------------------------------------------------------------------------------------------------------------------
- (void) performWithProgressViewController:(ProgressViewController*) progressViewController
		progress:(const I<CProgress>&) progress procDispatchQueue:(dispatch_queue_t) procDispatchQueue proc:(Proc) proc
		cancelProc:(CancelProc) cancelProc completionProc:(CompletionProc) completionProc
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
- (void) performWithProgressViewController:(ProgressViewController*) progressViewController
		progress:(const I<CProgress>&) progress proc:(Proc) proc cancelProc:(CancelProc) cancelProc
		completionProc:(CompletionProc) completionProc
{
	// Perform
	[self performWithProgressViewController:progressViewController progress:progress
			procDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) proc:proc
			cancelProc:cancelProc completionProc:completionProc];
}

@end
