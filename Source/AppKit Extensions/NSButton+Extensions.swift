//----------------------------------------------------------------------------------------------------------------------
//	NSButton+Extensions.swift			©2023 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSButton extension
public extension NSButton {

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	@objc convenience init(title :String, actionProc :@escaping (_ button :NSButton) -> Void) {
		// Do super
		self.init(title: title, target: nil, action: nil)

		// Set action
		self.actionProc = { actionProc($0 as! NSButton) }
	}

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	func showMenuOnLeftClick() {
		// Set action Proc
		self.actionProc =
				{ $0.menu?.popUp(positioning: $0.menu?.items.first, at: NSEvent.mouseLocation, in: nil) }
	}
}
