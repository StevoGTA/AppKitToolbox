//----------------------------------------------------------------------------------------------------------------------
//	AKTOutlineView.m			©2026 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTOutlineView.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTOutlineView

@implementation AKTOutlineView

// MARK: NSResponder methods

//----------------------------------------------------------------------------------------------------------------------
- (void) mouseDown:(NSEvent*) event
{
	// Check if option click is enabled and if that's what we got
	if (self.isOptionClickToBeginEditingEnabled &&
			(event.modifierFlags & NSEventModifierFlagDeviceIndependentFlagsMask) == NSEventModifierFlagOption) {
		// Start editing
		NSPoint			point = [self convertPoint:event.locationInWindow fromView:nil];

		NSInteger		rowIndex = [self rowAtPoint:point];
		id				item = [self itemAtRow:rowIndex];

		NSInteger		columnIndex = [self columnAtPoint:point];
		NSTableColumn*	tableColumn =
								(columnIndex < (NSInteger) self.tableColumns.count) ?
										self.tableColumns[columnIndex] : nil;
		if ([self.delegate outlineView:self shouldEditTableColumn:tableColumn item:item])
			// Start editing
			[self editColumn:columnIndex row:rowIndex withEvent:event select:YES];
	} else
		[super mouseDown:event];
}

@end
