//
//  NSProgressIndicator+Extensions.swift
//  AppKit Toolbox
//
//  Created by Stevo on 9/28/20.
//  Copyright © 2020 Stevo Brock. All rights reserved.
//

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSProgressIndicator extension
extension NSProgressIndicator {

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
