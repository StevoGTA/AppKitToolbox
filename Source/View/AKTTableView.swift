//
//  AKTTableView.swift
//  AppKit Toolbox
//
//  Created by Stevo on 5/15/23.
//

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTableView
public class AKTTableView : NSTableView {

	// MARK: Types
	public typealias MenuProc = (_ row :Int, _ tableColumnIndex :Int, _ tableColumn :NSTableColumn?) -> NSMenu?

	// MARK: Properties
	public	var	menuProc :MenuProc? = nil

	// MARK: NSView methods
	//------------------------------------------------------------------------------------------------------------------
	override public func menu(for event :NSEvent) -> NSMenu? {
		// Check if have menuProc
		if let menuProc = self.menuProc {
			// Setup
			let	point = convert(event.locationInWindow, from: nil)
			let	columnIndex = column(at: point)

			return menuProc(row(at: point), columnIndex, self.tableColumns[columnIndex])
		} else {
			// No menuProc
			return self.menu
		}
	}

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	public func adjustTableColumn(for identifier :NSUserInterfaceItemIdentifier,
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
