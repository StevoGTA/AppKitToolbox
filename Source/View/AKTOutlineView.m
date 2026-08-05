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
	// Setup
	NSPoint			point = [self convertPoint:event.locationInWindow fromView:nil];
	NSInteger		rowIndex = [self rowAtPoint:point];
	NSInteger		columnIndex = [self columnAtPoint:point];
	NSTableColumn*	tableColumn =
							((columnIndex >= 0) && (columnIndex < (NSInteger) self.tableColumns.count)) ?
									self.tableColumns[columnIndex] : nil;
	id				item = [self itemAtRow:rowIndex];

	if (self.isOptionClickToBeginEditingEnabled &&
			(event.modifierFlags & NSEventModifierFlagDeviceIndependentFlagsMask) == NSEventModifierFlagOption) {
		// Start editing on option-click
		if ([self.delegate outlineView:self shouldEditTableColumn:tableColumn item:item])
			[self editColumn:columnIndex row:rowIndex withEvent:event select:YES];
	} else if (self.isDoubleClickToBeginEditingEnabled && event.clickCount == 2) {
		// Start editing on double-click if allowed, otherwise fall through to default
		if ([self.delegate outlineView:self shouldEditTableColumn:tableColumn item:item])
			[self editColumn:columnIndex row:rowIndex withEvent:event select:YES];
		else
			[super mouseDown:event];
	} else
		[super mouseDown:event];
}

@end
