//
//  NSTableView+Extensions.swift
//  Media Tools
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
	func select(_ row :Int, byExtendingSelection extendingSelection :Bool = false) {
		// Select row indexes
		selectRowIndexes(IndexSet(integer: row), byExtendingSelection: extendingSelection)
	}
}
