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
}
