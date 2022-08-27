//----------------------------------------------------------------------------------------------------------------------
//	NSViewController+C++.mm			©2021 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "NSViewController+C++.h"

#import "NSString+C++.h"
#import "ProgressViewController+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSViewController extension

@implementation NSViewController (Cpp)

//----------------------------------------------------------------------------------------------------------------------
- (void) presentAlertWithStyle:(NSAlertStyle) alertStyle message:(const CString&) message
		information:(const CString&) information buttonTitles:(const TArray<CString>&) buttonTitles
		completionProc:(AlertCompletionProc) completionProc
{
	// Setup
	NSAlert*	alert = [[NSAlert alloc] init];
	alert.alertStyle = alertStyle;
	alert.messageText = [NSString stringForCString:message];
	alert.informativeText = [NSString stringForCString:information];
	for (TIteratorD<CString> iterator = buttonTitles.getIterator(); iterator.hasValue(); iterator.advance())
		// Add Button
		[alert addButtonWithTitle:[NSString stringForCString:*iterator]];

	// Present
	[alert beginSheetModalForWindow:self.view.window completionHandler:completionProc];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) presentAlertWithStyle:(NSAlertStyle) alertStyle message:(const CString&) message
		information:(const CString&) information buttonTitles:(const TArray<CString>&) buttonTitles
{
	[self presentAlertWithStyle:alertStyle message:message information:information buttonTitles:buttonTitles
			completionProc:nil];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) performWithProgressViewController:(ProgressViewController*) progressViewController
		progress:(const I<CProgress>&) progress procDispatchQueue:(dispatch_queue_t) procDispatchQueue
		proc:(ProgressProc) proc cancelProc:(ProgressCancelProc) cancelProc
		completionProc:(ProgressCompletionProc) completionProc
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
		progress:(const I<CProgress>&) progress proc:(ProgressProc) proc cancelProc:(ProgressCancelProc) cancelProc
		completionProc:(ProgressCompletionProc) completionProc
{
	// Perform
	[self performWithProgressViewController:progressViewController progress:progress
			procDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) proc:proc
			cancelProc:cancelProc completionProc:completionProc];
}

@end
