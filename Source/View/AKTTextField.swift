//----------------------------------------------------------------------------------------------------------------------
//	AKTTextField.swift		©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTextField
public class AKTTextField : NSTextField {

	// MARK: Properties
	@objc	public	var	didBeginEditingProc :(_ string :String) -> Void = { _ in }
	@objc	public	var	didChangeProc :(_ string :String) -> Void = { _ in }
	@objc	public	var	didEndEditingProc :(_ string :String) -> Void = { _ in }
	@objc	public	var	didCancelEditingProc :() -> Void = {}

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

		// Check if actually editing
		if self.currentEditor() != nil {
			// Call proc
			self.didEndEditingProc(self.stringValue)
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	override public func cancelOperation(_ sender :Any?) { self.didCancelEditingProc() }
}
