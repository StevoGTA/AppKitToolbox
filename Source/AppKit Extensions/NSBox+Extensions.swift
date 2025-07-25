//----------------------------------------------------------------------------------------------------------------------
//	NSBox+Extensions.swift			©2023 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSBox extensions
extension NSBox {

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc(setEnabled:animated:)
	public override func set(isEnabled :Bool, animated :Bool = false) {
		// Iterate subviews
		self.contentView?.subviews.forEach() {
			// Check if is NSControl
			if let control = $0 as? NSControl {
				// Update enabled
				if animated {
					// Animated
					control.animator().isEnabled = isEnabled
				} else {
					// Not animated
					control.isEnabled = isEnabled
				}
			}
		}
	}
}
