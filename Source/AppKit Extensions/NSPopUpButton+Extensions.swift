//
//  NSPopUpButton+Extensions.swift
//  AppKit Toolbox
//
//  Created by Stevo on 4/14/23.
//  Copyright © 2023 Stevo Brock. All rights reserved.
//

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSPopUpButton extension
extension NSPopUpButton {

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc func addItem(title :String, tag :Int) {
		// Add item and set tag
		addItem(withTitle: title)
		self.lastItem?.tag = tag
	}
}
