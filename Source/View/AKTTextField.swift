//----------------------------------------------------------------------------------------------------------------------
//	AKTTextField.swift		©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTextField
public class AKTTextField : NSTextField {

	// MARK: Properties
	@objc	public	var	isValueValid = true { didSet { self.needsDisplay = true } }

	@objc	public	var	shouldBeginEditingProc :(_ textField :AKTTextField, _ string :String) -> Bool = { _,_ in true }
	@objc	public	var	didBeginEditingProc :(_ textField :AKTTextField, _ string :String) -> Void = { _,_ in }

	@objc	public	var	didChangeProc :(_ textField :AKTTextField, _ string :String) -> Void = { _,_ in }

	@objc	public	var	shouldEndEditing :(_ textField :AKTTextField, _ string :String) -> Bool = { _,_ in true }
	@objc	public	var	didEndEditingProc
								:(_ textField :AKTTextField, _ string :String, _ textMovement :NSTextMovement) -> Void =
										{ _,_,_ in }

	@objc	public	var	didCancelEditingProc :(_ textField :AKTTextField) -> Void = { _ in}

			private	var	isCancellingOperation = false

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
	override public func textShouldBeginEditing(_ textObject :NSText) -> Bool {
		// Call proc
		return self.shouldBeginEditingProc(self, self.stringValue)
	}

	//------------------------------------------------------------------------------------------------------------------
	override public func textDidBeginEditing(_ notification :Notification) {
		// Do super
		super.textDidBeginEditing(notification)

		// Call proc
		self.didBeginEditingProc(self, self.stringValue)
	}

	//------------------------------------------------------------------------------------------------------------------
	override public func textDidChange(_ notification :Notification) {
		// Do super
		super.textDidChange(notification)

		// Call proc
		self.didChangeProc(self, self.stringValue)
	}

	//------------------------------------------------------------------------------------------------------------------
	override public func textShouldEndEditing(_ text :NSText) -> Bool { self.shouldEndEditing(self, self.stringValue) }

	//------------------------------------------------------------------------------------------------------------------
	override public func textDidEndEditing(_ notification :Notification) {
		// Do super
		super.textDidEndEditing(notification)

		// Get info
		let	textMovement =
					NSTextMovement(rawValue: (notification.userInfo?["NSTextMovement"] as? Int) ??
							NSTextMovement.other.rawValue)!

		// Check if cancelled
		if self.isCancellingOperation || (textMovement == .cancel) {
			// Cancelled
			self.didCancelEditingProc(self)
		} else {
			// Not cancelled
			self.didEndEditingProc(self, self.stringValue, textMovement)
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	override public func cancelOperation(_ sender :Any?) {
		// Cancel operation
		self.isCancellingOperation = true

		// Make something else the first responder
		self.window?.makeFirstResponder(nil)

		// All done
		self.isCancellingOperation = false
	}
}
