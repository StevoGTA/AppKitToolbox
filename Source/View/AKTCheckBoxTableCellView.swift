//----------------------------------------------------------------------------------------------------------------------
//	AKTCheckBoxTableCellView.swift		©2023 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTCheckBoxTableCellView
public class AKTCheckBoxTableCellView : NSTableCellView {

	// MARK: Properties
	public				var	state :NSControl.StateValue {
									get { self.checkBox.state }
									set { self.checkBox.state = newValue }
								}

	public				var	stateChangedProc :(_ state :NSControl.StateValue) -> Void = { _ in }

			@IBOutlet	var	checkBox :NSButton!

	// MARK: IBActions
	//------------------------------------------------------------------------------------------------------------------
	@IBAction func stateChanged(_ :NSButton) { self.stateChangedProc(self.state) }
}
