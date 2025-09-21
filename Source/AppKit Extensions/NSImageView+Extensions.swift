//----------------------------------------------------------------------------------------------------------------------
//	NSImageView+Extensions.swift			©2025 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSImageView extension
public extension NSImageView {

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc(isEditable:animated:)
	func set(isEditable :Bool, animated :Bool = false) {
		// Check animated
		if animated {
			// Animated
			self.animator().isEditable = isEditable
		} else {
			// Not animated
			self.isEditable = isEditable
		}
	}
}
