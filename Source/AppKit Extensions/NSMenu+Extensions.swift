//
//  NSMenu+Extensions.swift
//  AppKit Toolbox
//
//  Created by Stevo on 1/25/22.
//  Copyright © 2022 Stevo Brock. All rights reserved.
//

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSMenu extension
public extension NSMenu {

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	func addItem(withTitle title :String, action :Selector, representedObject :Any) {
		// Setup
		let	menuItem = NSMenuItem(title: title, action: action, keyEquivalent: "")
		menuItem.representedObject = representedObject

		// Add item
		addItem(menuItem)
	}
}
