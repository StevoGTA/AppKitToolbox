//----------------------------------------------------------------------------------------------------------------------
//	NSViewController+Extensions.swift			©2023 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSViewController extension
extension NSViewController {

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	func presentAlert(with alertStyle :NSAlert.Style, message :String, information :String, buttonTitles :[String],
			completion :@escaping (_ modalResponse :NSApplication.ModalResponse) -> Void = { _ in }) {
		// Setup
		let	alert = NSAlert(with: alertStyle, message: message, information: information, buttonTitles: buttonTitles)

		// Present
		alert.beginSheetModal(for: self.view.window!, completionHandler: completion)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func presentInformationalAlert(message :String, information :String, buttonTitles :[String],
			completion :@escaping (_ modalResponse :NSApplication.ModalResponse) -> Void = { _ in }) {
		// Present alert
		presentAlert(with: .informational, message: message, information: information, buttonTitles: buttonTitles,
				completion: completion)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func presentWarningAlert(message :String, information :String, buttonTitles :[String],
			completion :@escaping (_ modalResponse :NSApplication.ModalResponse) -> Void = { _ in }) {
		// Present alert
		presentAlert(with: .warning, message: message, information: information, buttonTitles: buttonTitles,
				completion: completion)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func presentCriticalAlert(message :String, information :String, buttonTitles :[String],
			completion :@escaping (_ modalResponse :NSApplication.ModalResponse) -> Void = { _ in }) {
		// Present alert
		presentAlert(with: .critical, message: message, information: information, buttonTitles: buttonTitles,
				completion: completion)
	}

	//------------------------------------------------------------------------------------------------------------------
	func presentAlert(with alertStyle :NSAlert.Style, message :String, information :String, buttonTitles :[String],
			showsSuppressionButton :Bool,
			completion :@escaping (_ modalResponse :NSApplication.ModalResponse, _ doNotShowAgain :Bool) -> Void =
					{ _,_ in }) {
		// Setup
		let	alert = NSAlert(with: alertStyle, message: message, information: information, buttonTitles: buttonTitles)
		alert.showsSuppressionButton = showsSuppressionButton

		// Present
		alert.beginSheetModal(for: self.view.window!) { [unowned alert] in
			// Call proc
			completion($0, alert.suppressionButton?.state == .on)
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func presentInformationalAlert(message :String, information :String, buttonTitles :[String],
			showsSuppressionButton :Bool = false,
			completion :@escaping (_ modalResponse :NSApplication.ModalResponse, _ doNotShowAgain :Bool) -> Void =
					{ _,_ in }) {
		// Present alert
		presentAlert(with: .informational, message: message, information: information, buttonTitles: buttonTitles,
				showsSuppressionButton: showsSuppressionButton, completion: completion)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func presentWarningAlert(message :String, information :String, buttonTitles :[String],
			showsSuppressionButton :Bool = false,
			completion :@escaping (_ modalResponse :NSApplication.ModalResponse, _ doNotShowAgain :Bool) -> Void =
					{ _,_ in }) {
		// Present alert
		presentAlert(with: .warning, message: message, information: information, buttonTitles: buttonTitles,
				showsSuppressionButton: showsSuppressionButton, completion: completion)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func presentCriticalAlert(message :String, information :String, buttonTitles :[String],
			showsSuppressionButton :Bool = false,
			completion :@escaping (_ modalResponse :NSApplication.ModalResponse, _ doNotShowAgain :Bool) -> Void =
					{ _,_ in }) {
		// Present alert
		presentAlert(with: .critical, message: message, information: information, buttonTitles: buttonTitles,
				showsSuppressionButton: showsSuppressionButton, completion: completion)
	}
}
