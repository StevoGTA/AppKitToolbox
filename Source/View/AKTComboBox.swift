//----------------------------------------------------------------------------------------------------------------------
//	AKTComboBox.swift		©2024 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTComboBox
public class AKTComboBox : NSComboBox {

	// MARK: Properties
	@objc	public	var	isValueValid = true { didSet { self.needsDisplay = true } }

	@objc	public	var	selectedItem :Any? {
								// Preflight
								guard let title = self.objectValueOfSelectedItem as? String else { return nil }

								return self.itemByTitle[title]
							}

	@objc	public	var	didBeginEditingProc :(_ string :String) -> Void = { _ in }
	@objc	public	var	didChangeProc :(_ string :String) -> Void = { _ in }
	@objc	public	var	didEndEditingProc :(_ string :String) -> Void = { _ in }

			private	var	itemByTitle = [String : Any]()

	// MARK: NSView methods
	//------------------------------------------------------------------------------------------------------------------
	override public func draw(_ dirtyRect :NSRect) {
		// Do super
		super.draw(dirtyRect)

		// Check if value is valid
		if !self.isValueValid {
			// Draw border indicating invalid state
			let	bezierPath =
						NSBezierPath(
								roundedRect:
										NSRect(x: 0.0, y: 0.0, width: self.bounds.width - 1.0,
												height: self.bounds.height - 1.0),
								xRadius: 5.5, yRadius: 5.5)
			bezierPath.lineWidth = 4.0

			NSGraphicsContext.saveGraphicsState()

			NSColor.systemRed.setStroke()
			bezierPath.stroke()

			NSGraphicsContext.restoreGraphicsState()
		}
	}

	// MARK: NSTextField methods
	//------------------------------------------------------------------------------------------------------------------
	override public func textDidBeginEditing(_ notification :Notification) {
		// Do super
		super.textDidBeginEditing(notification)

		// Call proc
		self.didBeginEditingProc(self.stringValue)
	}

	//------------------------------------------------------------------------------------------------------------------
	override public func textDidChange(_ notification :Notification) {
		// Do super
		super.textDidChange(notification)

		// Call proc
		self.didChangeProc(self.stringValue)
	}

	//------------------------------------------------------------------------------------------------------------------
	override public func textDidEndEditing(_ notification :Notification) {
		// Do super
		super.textDidEndEditing(notification)

		// Check if hidden
		if !self.isHidden {
			// Call proc
			self.didEndEditingProc(self.stringValue)
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
