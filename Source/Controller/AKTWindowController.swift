//----------------------------------------------------------------------------------------------------------------------
//	AKTWindowController.swift		©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTWindowController
open class AKTWindowController : NSWindowController, NSWindowDelegate {

	// MARK: Properties
	public	var	willCloseProc :(_ windowController :AKTWindowController) -> Void = { _ in }

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	override open func windowDidLoad() {
		// Do super
		super.windowDidLoad()

		// Setup
		self.window?.delegate = self
	}

	// MARK: NSWindowDelegate methods
	//------------------------------------------------------------------------------------------------------------------
	public func windowWillClose(_ notification :Notification) {
		// Call proc
		self.willCloseProc(self)
	}
}
