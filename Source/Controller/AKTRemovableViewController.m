//----------------------------------------------------------------------------------------------------------------------
//	AKTRemovableViewController.m			©2025 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTRemovableViewController.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTRemovableViewController

@implementation AKTRemovableViewController

// MARK: NSObject methods

//----------------------------------------------------------------------------------------------------------------------
- (void) awakeFromNib
{
	// Do super
	[super awakeFromNib];

	// Setup
	[self.removeButton setTarget:self];
	[self.removeButton setAction:@selector(remove:)];
}

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (void) setRemoveButtonEnabled:(BOOL) enabled
{
	self.removeButton.enabled = enabled;
}

// MARK: IBAction methods

//----------------------------------------------------------------------------------------------------------------------
- (IBAction) remove:(NSButton*) sender
{
	// Call proc
	self.removeProc();
}

@end
