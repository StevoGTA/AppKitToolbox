//----------------------------------------------------------------------------------------------------------------------
//	AKTComboBox.swift		©2024 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTComboBox
public class AKTComboBox : NSComboBox {

	// MARK: Properties
			public	var	isEmpty :Bool { self.stringValue.isEmpty }

	@objc	public	var	selectedItem :Any? {
								// Preflight
								guard let title = self.objectValueOfSelectedItem as? String else { return nil }

								return self.itemByTitle[title]
							}

	@objc	public	var	textDidBeginEditingProc :(_ string :String) -> Void = { _ in }
	@objc	public	var	textDidChangeProc :(_ string :String) -> Void = { _ in }
	@objc	public	var	textDidEndEditingProc :(_ string :String) -> Void = { _ in }

			private	var	itemByTitle = [String : Any]()

	// MARK: NSTextField methods
	//------------------------------------------------------------------------------------------------------------------
	override public func textDidBeginEditing(_ notification :Notification) {
		// Do super
		super.textDidBeginEditing(notification)

		// Call proc
		self.textDidBeginEditingProc(self.stringValue)
	}

	//------------------------------------------------------------------------------------------------------------------
	override public func textDidChange(_ notification :Notification) {
		// Do super
		super.textDidChange(notification)

		// Call proc
		self.textDidChangeProc(self.stringValue)
	}

	//------------------------------------------------------------------------------------------------------------------
	override public func textDidEndEditing(_ notification :Notification) {
		// Do super
		super.textDidEndEditing(notification)

		// Check if hidden
		if !self.isHidden {
			// Call proc
			self.textDidEndEditingProc(self.stringValue)
		}
	}

	// MARK: Instance  methods
	//------------------------------------------------------------------------------------------------------------------
	@objc(addItem:title:)
	public func add(item :Any, withTitle title :String) {
		// Add to map
		self.itemByTitle[title] = item

		// Add to menu
		addItem(withObjectValue: title)
	}
}
