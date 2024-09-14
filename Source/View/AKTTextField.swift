//----------------------------------------------------------------------------------------------------------------------
//	AKTTextField.swift		©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTextField
public class AKTTextField : NSTextField {

	// MARK: Properties
			public	var	isEmpty :Bool { self.stringValue.isEmpty }
	
	@objc	public	var	textDidBeginEditingProc :(_ string :String) -> Void = { _ in }
	@objc	public	var	textDidChangeProc :(_ string :String) -> Void = { _ in }
	@objc	public	var	textDidEndEditingProc :(_ string :String) -> Void = { _ in }

	@objc	public	var	cancelProc :() -> Void = {}

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

	//------------------------------------------------------------------------------------------------------------------
	override public func cancelOperation(_ sender :Any?) { self.cancelProc() }
}
