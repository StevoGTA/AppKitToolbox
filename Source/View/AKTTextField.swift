//----------------------------------------------------------------------------------------------------------------------
//	AKTTextField.swift		©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTextField
public class AKTTextField : NSTextField {

	// MARK: Properties
	public	var	isEmpty :Bool { self.stringValue.isEmpty }
	
	public	var	textDidBeginEditingProc :(_ string :String) -> Void = { _ in }
	public	var	textDidChangeProc :(_ string :String) -> Void = { _ in }
	public	var	textDidEndEditingProc :(_ string :String) -> Void = { _ in }

	// MARK: NSTextField methods
	//------------------------------------------------------------------------------------------------------------------
	public override func textDidBeginEditing(_ notification :Notification) {
		// Do super
		super.textDidBeginEditing(notification)

		// Call proc
		self.textDidBeginEditingProc(self.stringValue)
	}

	//------------------------------------------------------------------------------------------------------------------
	public override func textDidChange(_ notification :Notification) {
		// Do super
		super.textDidChange(notification)

		// Call proc
		self.textDidChangeProc(self.stringValue)
	}

	//------------------------------------------------------------------------------------------------------------------
	public override func textDidEndEditing(_ notification :Notification) {
		// Do super
		super.textDidEndEditing(notification)

		// Call proc
		self.textDidEndEditingProc(self.stringValue)
	}
}
