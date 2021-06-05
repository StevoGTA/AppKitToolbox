//----------------------------------------------------------------------------------------------------------------------
//	ProgressViewController.swift			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: ProgressViewController
class ProgressViewController : NSViewController {

	// MARK: Types
	typealias CancelProc = () -> Void

	// MARK: Properties
	@objc			var	cancelProc :CancelProc? {
								didSet {
									// Setup UI
									_ = self.view
									self.cancelButton?.isHidden = true
								}
							}
		@IBOutlet	var	messageLabel :NSTextField!
		@IBOutlet	var	indeterminateProgressIndicator :NSProgressIndicator!
		@IBOutlet	var	determinateProgressIndicator :NSProgressIndicator!
		@IBOutlet	var	cancelButton :NSButton?

	// MARK: NSViewController methods
	//------------------------------------------------------------------------------------------------------------------
	override func awakeFromNib() {
		// Do super
		super.awakeFromNib()

		// Setup UI
		self.cancelButton?.isHidden = true
	}
}
