//----------------------------------------------------------------------------------------------------------------------
//	NSOutlineView+Extensions.swift			©2020 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSOutlineView extension
public extension NSOutlineView {

	// MARK: Properties
	var	selectedItems :[Any] { items(for: self.selectedRowIndexes) }

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	func items(for rowIndexes :IndexSet) -> [Any] { rowIndexes.map({ item(atRow: $0)! }) }

	//------------------------------------------------------------------------------------------------------------------
	func itemsForContextualMenuAction(forClickedRow row :Int) -> [Any] {
		return items(for: rowIndexesForContextualMenuAction(forClickedRow: row))
	}

	//------------------------------------------------------------------------------------------------------------------
	func rowIndexesForContextualMenuAction(forClickedRow row :Int) -> IndexSet {
		// Setup
		let	selectedRowIndexes = self.selectedRowIndexes

		// Check clicked row
		if row != -1 {
			// Clicked on content
			if selectedRowIndexes.contains(row) {
				// Contextual menu row is in selection
				return selectedRowIndexes
			} else {
				// Contextual menu row is not in selection
				return IndexSet(integer: row)
			}
		} else {
			// Clicked outside content
			return selectedRowIndexes
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	func select(_ item :Any? = nil) {
		// Select
		selectRowIndexes((item != nil) ? IndexSet(integer: row(forItem: item)) : IndexSet(),
				byExtendingSelection: false)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func removeAllTableColumns() {
		// Remove all but the outline table column
		self.tableColumns.filter({ $0 != self.outlineTableColumn }).forEach({ self.removeTableColumn($0) })
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
