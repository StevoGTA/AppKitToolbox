//----------------------------------------------------------------------------------------------------------------------
//	AKTSecureTextField.swift		©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTSecureTextField
public class AKTSecureTextField : NSSecureTextField {

	// MARK: Properties
	public	var	didBeginEditingProc :() -> Void = {}
	public	var	didChangeProc :(_ string :String) -> Void = { _ in }
	public	var	didEndEditingProc :() -> Void = {}
	public	var	didCancelEditingProc :() -> Void = {}

	// MARK: NSTextField methods
	//------------------------------------------------------------------------------------------------------------------
	override public func textDidBeginEditing(_ notification :Notification) {
		// Do super
		super.textDidBeginEditing(notification)

		// Call proc
		self.didBeginEditingProc()
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

		// Call proc
		self.didEndEditingProc()
	}

	//------------------------------------------------------------------------------------------------------------------
	override public func cancelOperation(_ sender :Any?) { self.didCancelEditingProc() }
}
