//
//  NSView+Extensions.swift
//  Sound Grinder
//
//  Created by Stevo on 5/28/21.
//

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSView extension
extension NSView {

	// MARK: Properties
	@objc	var backgroundColor :NSColor? {
						get {
							// Retrieve color
							guard let color = layer?.backgroundColor else { return nil }

							return NSColor(cgColor: color)
						}
						set {
							// Update
							self.wantsLayer = true
							self.layer?.backgroundColor = newValue?.cgColor
						}
					}
}
