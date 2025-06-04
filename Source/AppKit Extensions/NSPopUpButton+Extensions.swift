//----------------------------------------------------------------------------------------------------------------------
//	NSPopUpButton+Extensions.swift			©2023 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSPopUpButton extension
public extension NSPopUpButton {

	// MARK: Properties
	@objc	var	selectedRepresentedObject :Any? { self.selectedItem?.representedObject }

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc(addItem:)
	func add(item :NSMenuItem) { self.menu?.addItem(item) }

	//------------------------------------------------------------------------------------------------------------------
	@objc
	func addDisabledItem(withTitle title :String) {
		// Add item and set isEnabled
		self.addItem(withTitle: title)
		self.lastItem!.isEnabled = false
		self.lastItem!.set(validationProc: { _ in false }, actionProc: { _ in })
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc
	func addItem(withTitle title :String, tag :Int) {
		// Add item and set tag
		addItem(withTitle: title)
		self.lastItem!.tag = tag
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc
	func addItem(withTitle title :String, representedObject :Any) {
		// Add item and set associated value
		addItem(withTitle: title)
		self.lastItem!.representedObject = representedObject
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc
	func addItem(withTitle title :String, target :AnyObject, action :Selector) {
		// Add item and set associated value
		addItem(withTitle: title)
		self.lastItem!.target = target
		self.lastItem!.action = action
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc
	func addItem(withTitle title :String, tag :Int, validationProc :@escaping NSMenuItem.ValidationProc,
			actionProc :@escaping NSMenuItem.ActionProc) {
		// Add item and set associated value
		addItem(withTitle: title)
		self.lastItem!.tag = tag
		self.lastItem!.set(validationProc: validationProc, actionProc: actionProc)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc
	func addItem(withTitle title :String, tag :Int, proc :@escaping NSMenuItem.ActionProc) {
		// Add item and set associated value
		addItem(withTitle: title)
		self.lastItem!.tag = tag
		self.lastItem!.actionProc = proc
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc
	func addItem(withTitle title :String, proc :@escaping NSMenuItem.ActionProc) {
		// Add item and set associated value
		addItem(withTitle: title)
		self.lastItem!.actionProc = proc
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc
	func addSeparatorItem() {
		// Add item
		self.menu?.addItem(NSMenuItem.separator())
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc
	func addSubmenu(_ submenu :NSMenu, withTitle title :String) {
		// Add submenu
		addItem(withTitle: title)
		self.lastItem!.submenu = submenu
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc
	func menuItem(matchingProc :(_ menuItem :NSMenuItem) -> Bool, deep :Bool = false) -> NSMenuItem? {
		// Call through to menu
		return self.menu?.menuItem(matchingProc: matchingProc, deep: deep)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc
	func menuItem(withRepresentedObject representedObject :Any, deep :Bool = false) -> NSMenuItem? {
		// Call through to menu
		return self.menu?.menuItem(representedObject: representedObject, deep: deep)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc
	func selectItem(withRepresentedObject representedObject :Any) {
		// Select
		select(menuItem(withRepresentedObject: representedObject))
	}
}
