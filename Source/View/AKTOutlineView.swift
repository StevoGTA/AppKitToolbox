//
//  AKTOutlineView.swift
//  AppKit Toolbox
//
//  Created by Stevo Brock on 11/2/24.
//  Copyright © 2024 Stevo Brock. All rights reserved.
//

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTOutlineView
public class AKTOutlineView : NSOutlineView {

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
