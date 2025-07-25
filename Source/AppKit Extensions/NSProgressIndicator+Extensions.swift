//----------------------------------------------------------------------------------------------------------------------
//	NSProgressIndicator+Extensions.swift			©2020 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSProgressIndicator extension
public extension NSProgressIndicator {

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	func set(animating :Bool, sender :Any? = nil) {
		// Check animating
		if animating {
			// Animating
			startAnimation(sender)
		} else {
			// Not animating
			stopAnimation(sender)
		}
	}
}
