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
	func set(isEditable :Bool, animated :Bool = false) {
		// Check animated
		if animated {
			// Animated
			self.animator().isBordered = isEditable
			self.animator().textColor = isEditable ? .controlTextColor : .labelColor
			self.animator().drawsBackground = isEditable
			self.animator().backgroundColor = isEditable ? .controlBackgroundColor : .textBackgroundColor
			self.animator().isEditable = isEditable
		} else {
			// Not animated
			self.isBordered = isEditable
			self.textColor = isEditable ? .controlTextColor : .labelColor
			self.drawsBackground = isEditable
			self.backgroundColor = isEditable ? .controlBackgroundColor : .textBackgroundColor
			self.isEditable = isEditable
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(stringValue:animated:)
	func set(stringValue :String, animated :Bool) {
		// Check animated
		if animated {
			// Animated
			self.animator().stringValue = stringValue
		} else {
			// Not animated
			self.stringValue = stringValue
		}
	}
}
