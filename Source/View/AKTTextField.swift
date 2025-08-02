//----------------------------------------------------------------------------------------------------------------------
//	AKTTextField.swift		©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTextField
public class AKTTextField : NSTextField {

	// MARK: Properties
	@objc	public	var	isValueValid = true

	@objc	public	var	didBeginEditingProc :(_ string :String) -> Void = { _ in }
	@objc	public	var	didChangeProc :(_ string :String) -> Void = { _ in }
	@objc	public	var	shouldEndEditing :(_ string :String) -> Bool = { _ in true }
	@objc	public	var	didEndEditingProc :(_ string :String) -> Void = { _ in }
	@objc	public	var	didCancelEditingProc :() -> Void = {}

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
										NSRect(x: 0.0, y: 1.0, width: self.bounds.width,
												height: self.bounds.height - 1.0),
								xRadius: 2.0, yRadius: 2.0)
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
	override public func textShouldEndEditing(_ text :NSText) -> Bool { self.shouldEndEditing(self.stringValue) }

	//------------------------------------------------------------------------------------------------------------------
	override public func textDidEndEditing(_ notification :Notification) {
		// Do super
		super.textDidEndEditing(notification)

		// Check if actually editing
		if self.currentEditor() != nil {
			// Call proc
			self.didEndEditingProc(self.stringValue)
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	override public func cancelOperation(_ sender :Any?) { self.didCancelEditingProc() }
}
