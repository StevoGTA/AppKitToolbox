//----------------------------------------------------------------------------------------------------------------------
//	NSMenu+Extensions.swift			©2022 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSMenu extension
public extension NSMenu {

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc func menuItem(matchingProc :(_ menuItem :NSMenuItem) -> Bool, deep :Bool = false) -> NSMenuItem? {
		// Iterate all NSMenuItems
		for menuItem in self.items {
			// Check this NSMenuItem
			if matchingProc(menuItem) {
				// Found it
				return menuItem
			} else if deep, let submenuItem = menuItem.submenu?.menuItem(matchingProc: matchingProc, deep: true) {
				// Found it
				return submenuItem
			}
		}

		return nil
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func menuItem(identifier :NSUserInterfaceItemIdentifier, deep :Bool = false) -> NSMenuItem? {
		// Search for NSMenuItem by representedObject
		return menuItem(matchingProc: { $0.identifier == identifier }, deep: deep)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func menuItem(representedObject :Any, deep :Bool = false) -> NSMenuItem? {
		// Search for NSMenuItem by representedObject
		return menuItem(matchingProc: { ($0.representedObject as? NSObject)?.isEqual(to: representedObject) ?? false },
				deep: deep)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func addDisabledItem(title :String) {
		// Setup
		let	menuItem = NSMenuItem(title: title, action: nil, keyEquivalent: "")
		menuItem.isEnabled = false

		// Add item
		addItem(menuItem)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func addItem(title :String, target :AnyObject? = nil, action :Selector? = nil,
			representedObject :Any? = nil) {
		// Setup
		let	menuItem = NSMenuItem(title: title, action: action, keyEquivalent: "")
		menuItem.target = target
		menuItem.representedObject = representedObject

		// Add item
		addItem(menuItem)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc
	func addItem(withTitle title :String, proc :@escaping NSMenuItem.ActionProc) {
		// Setup
		let	menuItem = NSMenuItem(title: title, action: nil, keyEquivalent: "")
		menuItem.actionProc = proc

		// Add item
		addItem(menuItem)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func addItem(title :String, menu :NSMenu) {
		// Setup
		let	menuItem = NSMenuItem(title: title, action: nil, keyEquivalent: "")
		menuItem.submenu = menu

		// Add item
		addItem(menuItem)
	}
}
