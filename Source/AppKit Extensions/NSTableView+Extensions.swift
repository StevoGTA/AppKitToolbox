//----------------------------------------------------------------------------------------------------------------------
//	NSTableView+Extensions.swift			©2020 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSTableView extension
public extension NSTableView {

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc func reloadDataRetainingSelection() {
		// Setup
		let	selectedRowIndexes = self.selectedRowIndexes

		// Reload data
		reloadData()

		// Reset selection
		self.selectRowIndexes(selectedRowIndexes, byExtendingSelection: false)
	}

	//------------------------------------------------------------------------------------------------------------------
	func reloadColumn(at index :Int) {
		// Reload data
		reloadData(forRowIndexes: IndexSet(0..<self.numberOfRows), columnIndexes: IndexSet(integer: index))
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func reloadColumn(for identifier :NSUserInterfaceItemIdentifier) {
		// Retrieve index
		guard let index = self.tableColumns.firstIndex(where: { $0.identifier == identifier }) else { return }

		// Reload
		reloadColumn(at: index)
	}

	//------------------------------------------------------------------------------------------------------------------
	func reloadRows(at indexSet :IndexSet) {
		// Reload data
		reloadData(forRowIndexes: indexSet, columnIndexes: IndexSet(0..<self.numberOfColumns))
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func select(_ rowIndex :Int, byExtendingSelection extendingSelection :Bool = false) {
		// Select row indexes
		selectRowIndexes(IndexSet(integer: rowIndex), byExtendingSelection: extendingSelection)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func continueEditing(from tableColumn :NSTableColumn, in rowIndex :Int, given textMovement :NSTextMovement) {
		// Check text movement
		switch textMovement {
			case .tab:
				// Tab - move to next editable table column
				if let tableColumnIndex = self.tableColumns.firstIndex(of: tableColumn),
						let nextColumnIndex =
								self.tableColumns[(tableColumnIndex + 1)...].firstIndex(where: { $0.isEditable }) {
					// Wait a beate
					DispatchQueue.main.async() { [weak self] in
						// Start editing
						self?.editColumn(nextColumnIndex, row: rowIndex, with: nil, select: true)
					}
				}

			case .backtab:
				// Backtab - move to previous editable table column
				if let tableColumnIndex = self.tableColumns.firstIndex(of: tableColumn),
						let previousColumnIndex =
								self.tableColumns[...(tableColumnIndex - 1)].lastIndex(where: { $0.isEditable }) {
					// Wait a beate
					DispatchQueue.main.async() { [weak self] in
						// Start editing
						self?.editColumn(previousColumnIndex, row: rowIndex, with: nil, select: true)
					}
				}

			default:
				// Do nothing
				break
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	func adjustTableColumn(for identifier :NSUserInterfaceItemIdentifier,
			given content :[(row :Int, string :String)], padding :CGFloat = 0.0) {
		// Preflight
		guard let tableColumn = self.tableColumns.first(where: { $0.identifier == identifier }) else { return }
		let	tableColumnIndex = self.tableColumns.firstIndex(of: tableColumn)!

		// Sort content
		let	contentSorted = content.sorted(by: { $0.string.count > $1.string.count })

		// Iterate rows in reverse order of content length looking for longest width.  Punt after we believe we won't
		//	find another row with a greater width
		var	width = tableColumn.minWidth
		var	rowsWithNoChange = 0
		for (row, _) in contentSorted {
			// Check this row
			let	tableCellView =
						self.view(atColumn: tableColumnIndex, row: row, makeIfNecessary: true) as! NSTableCellView
			let	tableCellViewWidth = ceil(tableCellView.textField!.cell!.cellSize.width)
			if tableCellViewWidth > width {
				// Update width
				width = tableCellViewWidth
				rowsWithNoChange = 0
			} else {
				// No change
				rowsWithNoChange += 1

				// Check if time to be done
				if rowsWithNoChange == 5 {
					// We done
					break
				}
			}
		}

		// Update table column
		tableColumn.width = width
	}
}
