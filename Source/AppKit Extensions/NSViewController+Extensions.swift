//----------------------------------------------------------------------------------------------------------------------
//	NSViewController+Extensions.swift			©2023 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSViewController extension
public extension NSViewController {

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	func presentAlert(with alertStyle :NSAlert.Style = .warning, message :String = "", information :String = "",
			buttonTitles :[String] = [], showsSuppressionButton :Bool = false,
			completionProc
					:@escaping (_ modalResponse :NSApplication.ModalResponse, _ doNotShowAgain :Bool) -> Void =
							{ _,_ in }) {
		// Setup
		let	alert = NSAlert(with: alertStyle, message: message, information: information, buttonTitles: buttonTitles)
		alert.showsSuppressionButton = showsSuppressionButton

		// Present
		alert.beginSheetModal(for: self.view.window!) { [unowned alert] in
			// Call proc
			completionProc($0, alert.suppressionButton?.state == .on)
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	func presentAlert(with alertStyle :NSAlert.Style = .warning, message :String = "", information :String = "",
			buttonTitles :[String] = [],
			completionProc :@escaping (_ modalResponse :NSApplication.ModalResponse) -> Void = { _ in }) {
		// Present alert
		presentAlert(with: alertStyle, message: message, information: information, buttonTitles: buttonTitles,
				completionProc: { _ = $1; completionProc($0) })
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func presentInformationalAlert(message :String, information :String, buttonTitles :[String],
			showsSuppressionButton :Bool = false,
			completionProc :@escaping (_ modalResponse :NSApplication.ModalResponse, _ doNotShowAgain :Bool) -> Void =
					{ _,_ in }) {
		// Present alert
		presentAlert(with: .informational, message: message, information: information, buttonTitles: buttonTitles,
				showsSuppressionButton: showsSuppressionButton, completionProc: completionProc)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func presentInformationalAlert(message :String, information :String, buttonTitles :[String],
			completionProc :@escaping (_ modalResponse :NSApplication.ModalResponse) -> Void = { _ in }) {
		// Present alert
		presentAlert(with: .informational, message: message, information: information, buttonTitles: buttonTitles,
				completionProc: completionProc)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func presentWarningAlert(message :String, information :String, buttonTitles :[String],
			showsSuppressionButton :Bool = false,
			completionProc :@escaping (_ modalResponse :NSApplication.ModalResponse, _ doNotShowAgain :Bool) -> Void =
					{ _,_ in }) {
		// Present alert
		presentAlert(with: .warning, message: message, information: information, buttonTitles: buttonTitles,
				showsSuppressionButton: showsSuppressionButton, completionProc: completionProc)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func presentWarningAlert(message :String, information :String, buttonTitles :[String],
			completionProc :@escaping (_ modalResponse :NSApplication.ModalResponse) -> Void = { _ in }) {
		// Present alert
		presentAlert(with: .warning, message: message, information: information, buttonTitles: buttonTitles,
				completionProc: completionProc)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func presentCriticalAlert(message :String, information :String, buttonTitles :[String],
			showsSuppressionButton :Bool = false,
			completionProc :@escaping (_ modalResponse :NSApplication.ModalResponse, _ doNotShowAgain :Bool) -> Void =
					{ _,_ in }) {
		// Present alert
		presentAlert(with: .critical, message: message, information: information, buttonTitles: buttonTitles,
				showsSuppressionButton: showsSuppressionButton, completionProc: completionProc)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func presentCriticalAlert(message :String, information :String, buttonTitles :[String],
			completionProc :@escaping (_ modalResponse :NSApplication.ModalResponse) -> Void = { _ in }) {
		// Present alert
		presentAlert(with: .critical, message: message, information: information, buttonTitles: buttonTitles,
				completionProc: completionProc)
	}
}
