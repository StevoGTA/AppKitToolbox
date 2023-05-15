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

	// MARK: Properties
	var	menuProc :(_ row :Int, _ columnIndex :Int, _ column :NSTableColumn?) -> NSMenu? = { _,_,_ in nil }

	// MARK: NSView methods
	//------------------------------------------------------------------------------------------------------------------
	override public func menu(for event :NSEvent) -> NSMenu? {
		// Setup
		let	point = convert(event.locationInWindow, from: nil)
		let	columnIndex = column(at: point)

		return self.menuProc(row(at: point), columnIndex, self.tableColumns[columnIndex])
	}
}
