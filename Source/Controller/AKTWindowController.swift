//----------------------------------------------------------------------------------------------------------------------
//	AKTWindowController.swift		©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTWindowController
open class AKTWindowController : NSWindowController, NSWindowDelegate {

	// MARK: Types

	// MARK: Properties
	public	var	willCloseProc :() -> Void = {}

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	override public func windowDidLoad() {
		// Do super
		super.windowDidLoad()

		// Setup
		self.window?.delegate = self
	}

	// MARK: NSWindowDelegate methods
	//------------------------------------------------------------------------------------------------------------------
	public func windowWillClose(_ notification :Notification) {
		// Call proc
		self.willCloseProc()
	}
}
