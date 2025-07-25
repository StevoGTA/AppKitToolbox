//
//  AKTTableHeaderView.swift
//  Swift Toolbox
//
//  Created by Stevo on 7/7/25.
//

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTableHeaderView
public class AKTTableHeaderView : NSTableHeaderView {

	// MARK: Properties
	public	var	menuProc :(_ tableView :NSTableView, _ tableColumn :NSTableColumn, _ tableColumnIndex :Int) -> NSMenu? =
					{ _,_,_ in nil }

	//------------------------------------------------------------------------------------------------------------------
	// MARK: NSView methods
	override public func menu(for event :NSEvent) -> NSMenu? {
		// Preflight
		guard let tableView = self.tableView else { return nil }

		let	columnIndex = column(at: convert(event.locationInWindow, from: nil))
		if (columnIndex >= 0) && (columnIndex < tableView.numberOfColumns) {
			// Call menuProc
			return self.menuProc(tableView, tableView.tableColumns[columnIndex], columnIndex)
		} else {
			//
			return nil
		}
	}
}
