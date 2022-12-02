//----------------------------------------------------------------------------------------------------------------------
//	AKTProgressViewController.swift			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTProgressViewController
public class AKTProgressViewController : NSViewController {

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
	override public func viewDidLoad() {
		// Do super
		super.viewDidLoad()

		// Setup UI
		self.messageLabel.stringValue = ""

		self.progressIndicator.isIndeterminate = true
		self.progressIndicator.doubleValue = 0.0

		self.cancelButton?.isHidden = true
	}

	// MARK: IBAction methods
	//------------------------------------------------------------------------------------------------------------------
	@IBAction func cancel(_ :NSButton) { self.cancelProc?() }
}
