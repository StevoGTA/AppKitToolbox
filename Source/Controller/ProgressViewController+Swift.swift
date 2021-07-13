//----------------------------------------------------------------------------------------------------------------------
//	ProgressViewController+Swift.swift			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------
// MARK: ProgressViewController extension
public extension ProgressViewController {

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	func set(_ progress :Progress) {
		// Setup
		progress.messageUpdatedProc = { [unowned self] in self.updateMessage($0) }
		progress.valueUpdatedProc = { [unowned self] in self.updateValue($0) }

		// Update UI
		updateMessage(progress.message)
		updateValue(progress.value)
	}

	// MARK: Private methods
	//------------------------------------------------------------------------------------------------------------------
	private func updateMessage(_ message :String) { self.messageLabel.stringValue = message }

	//------------------------------------------------------------------------------------------------------------------
	private func updateValue(_ value :Float?) {
		// Update progress indicator view
		self.progressIndicator.isIndeterminate = value == nil
		self.progressIndicator.doubleValue = Double(value ?? 0.0)
	}
}
