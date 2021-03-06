//----------------------------------------------------------------------------------------------------------------------
//	ProgressViewController+C++.mm			©2021 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "ProgressViewController+C++.h"

#import "NSString+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: Local proc declarations

static	void	sProc(const CProgress& progress, ProgressViewController* progressViewController);

//----------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
// MARK: - ProgressViewController extension

@implementation ProgressViewController (Cpp)

// MARK: Properties

//----------------------------------------------------------------------------------------------------------------------
- (CProgress::UpdateInfo) progressUpdateInfo
{
	return CProgress::UpdateInfo((CProgress::UpdateInfo::Proc) sProc, (__bridge void*) self);
}

// MARK: Private methods

//----------------------------------------------------------------------------------------------------------------------
- (void) updateUIWithMessage:(NSString*) message isIndeterminate:(BOOL) isIndeterminate value:(Float32) value
{
(void) self.view;

	// Update UI
	self.messageLabel.stringValue = message;

	if (!isIndeterminate) {
		// Have progress
		[self.indeterminateProgressIndicator stopAnimation:self];

		self.determinateProgressIndicator.hidden = NO;
		self.determinateProgressIndicator.doubleValue = value;
	} else {
		// Don't have progress
		[self.indeterminateProgressIndicator startAnimation:self];

		self.determinateProgressIndicator.hidden = YES;
	}
}

@end

//----------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
// MARK: Local proc definitions

//----------------------------------------------------------------------------------------------------------------------
void sProc(const CProgress& progress, ProgressViewController* progressViewController)
//----------------------------------------------------------------------------------------------------------------------
{
	// Setup
	NSString*	message = [NSString stringForCString:progress.getMessage()];

	OV<Float32>	value = progress.getValue();
	BOOL	isIndeterminate = !value.hasValue();
	Float32	determinateValue = value.hasValue() ? value.getValue() : 0.0;

	// Check thread
	if (NSThread.currentThread == NSThread.mainThread)
		// Already on main thread
		[progressViewController updateUIWithMessage:message isIndeterminate:isIndeterminate value:determinateValue];
	else
		// Update UI on main thread
		dispatch_async(dispatch_get_main_queue(), ^{
			// Update UI
			[progressViewController updateUIWithMessage:message isIndeterminate:isIndeterminate value:determinateValue];
		});
}
