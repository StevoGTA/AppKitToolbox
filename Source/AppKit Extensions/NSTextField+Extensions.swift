//----------------------------------------------------------------------------------------------------------------------
//	NSTextField+Extensions.swift			©2025 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSTextField extension
public extension NSTextField {

	// MARK: Properties
	@objc	var	isEmpty :Bool { self.stringValue.isEmpty }

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc(setEditable:animated:)
	func set(editable :Bool, animated :Bool = false) {
		// Check animated
		if animated {
			// Animated
			self.animator().isBordered = editable
			self.animator().textColor = editable ? .controlTextColor : .labelColor
			self.animator().drawsBackground = editable
			self.animator().backgroundColor = editable ? .controlBackgroundColor : .textBackgroundColor
			self.animator().isEditable = editable
		} else {
			// Not animated
			self.isBordered = editable
			self.textColor = editable ? .controlTextColor : .labelColor
			self.drawsBackground = editable
			self.backgroundColor = editable ? .controlBackgroundColor : .textBackgroundColor
			self.isEditable = editable
		}
	}
}
