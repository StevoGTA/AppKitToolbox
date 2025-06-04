//----------------------------------------------------------------------------------------------------------------------
//	NSOutlineView+Extensions.swift			©2020 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSOutlineView extension
extension NSOutlineView {

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	func select(_ item :Any? = nil) {
		// Select
		selectRowIndexes((item != nil) ? IndexSet(integer: row(forItem: item)) : IndexSet(),
				byExtendingSelection: false)
	}

	//------------------------------------------------------------------------------------------------------------------
	func remove(_ items :[Any], parent :Any? = nil,
			withAnimation tableViewAnimationOptions :NSTableView.AnimationOptions = [.slideUp]) {
		// Setup
		var	indexSet = IndexSet()
		if parent != nil {
			// Have parent
			items.forEach() { indexSet.insert(childIndex(forItem: $0)) }
		} else {
			// No parent
			items.forEach() { indexSet.insert(row(forItem: $0)) }
		}

		// Remove
		removeItems(at: indexSet, inParent: parent, withAnimation: tableViewAnimationOptions)
	}
}
