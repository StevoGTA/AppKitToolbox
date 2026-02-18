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

	private	var	doubleActionDidBeginEditingProc :() -> Void = {}

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
	@objc func setDoubleActionToEditCell(_ doubleActionDidBeginEditingProc :@escaping () -> Void) {
		// Store
		self.doubleActionDidBeginEditingProc = doubleActionDidBeginEditingProc

		// Setup
		self.target = self
		self.doubleAction = #selector(doubleActionEditCell)
	}

	// MARK: Private methods
	//------------------------------------------------------------------------------------------------------------------
	@objc private func doubleActionEditCell(_ sender :Any) {
		// Ensure we clicked on something
		let	clickedRow = self.clickedRow
		guard clickedRow != -1 else { return }

		// Start editing
		editColumn(self.clickedColumn, row: clickedRow, with: nil, select: true)

		// Call proc
		self.doubleActionDidBeginEditingProc()
	}
}
