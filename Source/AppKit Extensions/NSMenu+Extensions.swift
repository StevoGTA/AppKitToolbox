//----------------------------------------------------------------------------------------------------------------------
//	NSMenu+Extensions.swift			©2022 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSMenu extension
@MainActor
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
	@objc(menuItemForIdentifier:deep:)
	func menuItem(for identifier :NSUserInterfaceItemIdentifier, deep :Bool = false) -> NSMenuItem? {
		// Search for NSMenuItem by representedObject
		return menuItem(matchingProc: { $0.identifier == identifier }, deep: deep)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(menuItemForRepresentedObject:deep:)
	func menuItem(for representedObject :Any, deep :Bool = false) -> NSMenuItem? {
		// Search for NSMenuItem by representedObject
		return menuItem(matchingProc: { ($0.representedObject as? NSObject)?.isEqual(to: representedObject) ?? false },
				deep: deep)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(menuItemForSelector:deep:)
	func menuItem(for selector :Selector, deep :Bool = false) -> NSMenuItem? {
		// Search for NSMenuItem by representedObject
		return menuItem(matchingProc: { $0.action == selector }, deep: deep)
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
	func addItem(withTitle title :String, validationProc :@escaping NSMenuItem.ValidationProc,
			actionProc :@escaping NSMenuItem.ActionProc) {
		// Setup
		let	menuItem = NSMenuItem(title: title, action: nil, keyEquivalent: "")
		menuItem.set(validationProc: validationProc, actionProc: actionProc)

		// Add item
		addItem(menuItem)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc
	func addItem(withTitle title :String, state :NSControl.StateValue, proc :@escaping NSMenuItem.ActionProc) {
		// Setup
		let	menuItem = NSMenuItem(title: title, action: nil, keyEquivalent: "")
		menuItem.state = state
		menuItem.actionProc = proc

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
	@objc
	func addItem(withTitle title :String, tag :Int, proc :@escaping NSMenuItem.ActionProc) {
		// Setup
		let	menuItem = NSMenuItem(title: title, action: nil, keyEquivalent: "")
		menuItem.tag = tag
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
