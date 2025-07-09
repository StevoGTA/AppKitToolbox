//----------------------------------------------------------------------------------------------------------------------
//	NSTextView+Extensions.swift			©2025 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSTextView extension
public extension NSTextView {

	// MARK: Properties
	@objc	var	isEmpty :Bool { self.textStorage?.string.isEmpty ?? true }
}
