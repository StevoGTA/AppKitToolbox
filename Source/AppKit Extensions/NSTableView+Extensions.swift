//
//  NSTableView+Extensions.swift
//  AppKit Toolbox
//
//  Created by Stevo on 9/28/20.
//  Copyright © 2020 Stevo Brock. All rights reserved.
//

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSTableView extension
extension NSTableView {

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc func reloadDataRetainingSelection() {
		// Get current selection
		let	selectedRowIndexes = self.selectedRowIndexes

		// Reload data
		reloadData()

		// Reset selection
		self.selectRowIndexes(selectedRowIndexes, byExtendingSelection: false)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func select(_ rowIndex :Int, byExtendingSelection extendingSelection :Bool = false) {
		// Select row indexes
		selectRowIndexes(IndexSet(integer: rowIndex), byExtendingSelection: extendingSelection)
	}
}
