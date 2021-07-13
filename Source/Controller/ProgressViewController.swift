//----------------------------------------------------------------------------------------------------------------------
//	ProgressViewController.swift			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: ProgressViewController
public class ProgressViewController : NSViewController {

	// MARK: Types
	public typealias CancelProc = () -> Void

	// MARK: Properties
	@objc	public		var	cancelProc :CancelProc? {
									didSet {
										// Setup UI
										_ = self.view
										self.cancelButton?.isHidden = self.cancelProc == nil;
									}
								}

			@IBOutlet	var	messageLabel :NSTextField!
			@IBOutlet	var	progressIndicator :NSProgressIndicator!
			@IBOutlet	var	cancelButton :NSButton?

	// MARK: NSViewController methods
	//------------------------------------------------------------------------------------------------------------------
	override public func awakeFromNib() {
		// Do super
		super.awakeFromNib()

		// Setup UI
		self.cancelButton?.isHidden = true
	}

	// MARK: IBAction methods
	//------------------------------------------------------------------------------------------------------------------
	@IBAction func cancel(_ :NSButton) { self.cancelProc?() }
}
