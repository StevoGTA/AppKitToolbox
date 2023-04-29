//----------------------------------------------------------------------------------------------------------------------
//	NSBox+Extensions.swift			©2023 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSBox extensions
extension NSBox {

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc(setEnabled:) func set(enabled :Bool) {
		// Iterate subviews
		self.contentView?.subviews.forEach() {
			// Check if is NSControl
			if let control = $0 as? NSControl {
				// Update enabled
				control.isEnabled = enabled
			}
		}
	}
}
