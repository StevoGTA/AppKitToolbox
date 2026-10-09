//----------------------------------------------------------------------------------------------------------------------
//	AKTDatePicker.swift			©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTDatePicker
class AKTDatePicker : NSDatePicker {

	// MARK: Properties
	var	didEndEditingProc :(_ datePicker :AKTDatePicker) -> Void = { _ in }

	// MARK: NSResponder methods
	//------------------------------------------------------------------------------------------------------------------
	override func resignFirstResponder() -> Bool {
		// Do super
		let	didResign = super.resignFirstResponder()

		// Check if resigned
		if didResign {
			// Call proc
			self.didEndEditingProc(self)
		}

		return didResign
	}
}
