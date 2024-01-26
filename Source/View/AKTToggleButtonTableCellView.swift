//----------------------------------------------------------------------------------------------------------------------
//	AKTToggleButtonTableCellView.swift		©2023 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTToggleButtonTableCellView
public class AKTToggleButtonTableCellView : NSTableCellView {

	// MARK: Properties
	@objc	public				var	isEnabled :Bool {
											get { self.button.isEnabled }
											set { self.button.isEnabled = newValue }
										}
	@objc	public				var	state :NSControl.StateValue {
											get { self.button.state }
											set { self.button.state = newValue }
										}

	@objc	public				var	stateChangedProc :(_ state :NSControl.StateValue) -> Void = { _ in }

					@IBOutlet	var	button :NSButton!

	// MARK: IBActions
	//------------------------------------------------------------------------------------------------------------------
	@IBAction func stateChanged(_ :NSButton) { self.stateChangedProc(self.state) }
}
