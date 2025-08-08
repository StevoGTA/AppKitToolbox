//----------------------------------------------------------------------------------------------------------------------
//	AKTEditableRemovableViewController.m			©2025 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTEditableRemovableViewController.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTEditableRemovableViewController

@implementation AKTEditableRemovableViewController

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (void) setEditing:(BOOL) editing animated:(BOOL) animated
{
	// Update UI
	if (animated)
		// Animated
		super.removeButton.animator.hidden = !editing;
	else
		// Not animated
		super.removeButton.hidden = !editing;
}

// MARK: Instance methods for subclasses to use

//----------------------------------------------------------------------------------------------------------------------
- (void) noteContentChanged
{
	self.contentChangedProc();
}

// MARK: Instance methods for subclasses to implement as needed

//----------------------------------------------------------------------------------------------------------------------
- (BOOL) isContentValid
{
	return YES;
}

@end
