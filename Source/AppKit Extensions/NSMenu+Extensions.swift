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
	func addItem(withTitle title :String, target :AnyObject? = nil, action :Selector, representedObject :Any? = nil) {
		// Setup
		let	menuItem = NSMenuItem(title: title, action: action, keyEquivalent: "")
		menuItem.target = target
		menuItem.representedObject = representedObject

		// Add item
		addItem(menuItem)
	}

	//------------------------------------------------------------------------------------------------------------------
	func addItem(withTitle title :String, menu :NSMenu) {
		// Setup
		let	menuItem = NSMenuItem(title: title, action: nil, keyEquivalent: "")
		menuItem.submenu = menu

		// Add item
		addItem(menuItem)
	}
}
