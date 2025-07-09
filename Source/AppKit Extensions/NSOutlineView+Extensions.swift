//
//  NSOutlineView+Extensions.swift
//  AppKit Toolbox
//
//  Created by Stevo on 9/28/20.
//  Copyright © 2020 Stevo Brock. All rights reserved.
//

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSOutlineView extension
extension NSOutlineView {

	// MARK: Properties
	var	selectedItems :[Any] { items(for: self.selectedRowIndexes) }

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	func items(for rowIndexes :IndexSet) -> [Any] { rowIndexes.map({ item(atRow: $0)! }) }

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
