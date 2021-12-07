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
		progress:(CProgress&) progress procDispatchQueue:(dispatch_queue_t) procDispatchQueue proc:(Proc) proc
		cancelProc:(CancelProc) cancelProc completionProc:(CompletionProc) completionProc
{
	// Setup
	__block	BOOL	isCancelled = NO;
	progressViewController.cancelProc = ^{
		// Cancelled
		isCancelled = YES;

		// Call proc
		cancelProc();
	};

	// Present as sheet
	[self presentViewControllerAsSheet:progressViewController];

	// Perform on proc displatch queue
	__unsafe_unretained	typeof(self)	unsafeUnretainedSelf = self;
	dispatch_async(procDispatchQueue, ^{
		// Call proc
		void*	result = proc(unsafeUnretainedSelf, progress);

		// Jump to main queue
		dispatch_async(dispatch_get_main_queue(), ^{
			// Dismiss
			[unsafeUnretainedSelf dismissViewController:progressViewController];

			// Check cancelled
			if (!isCancelled)
				// Call completion proc
				completionProc(result);
		});
	});
}

//----------------------------------------------------------------------------------------------------------------------
- (void) performWithProgressViewController:(ProgressViewController*) progressViewController
		proc:(Proc) proc cancelProc:(CancelProc) cancelProc
		completionProc:(CompletionProc) completionProc
{
	// Setup
	I<CProgress>*	progress = new I<CProgress>(new CProgress(progressViewController.progressUpdateInfo));

	// Perform
	[self performWithProgressViewController:progressViewController progress:**progress
			procDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) proc:proc
			cancelProc:^{
				// Call proc
				cancelProc();

				// Cleanup
				delete progress;
			} completionProc:^(void* result){
				// Call proc
				completionProc(result);

				// Cleanup
				delete progress;
			}];
}

@end
