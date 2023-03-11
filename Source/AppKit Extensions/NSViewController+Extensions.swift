//----------------------------------------------------------------------------------------------------------------------
//	NSViewController+Extensions.swift			©2023 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: Local data
var	sReplacements = [(fromString :String, toString :String)]()

//----------------------------------------------------------------------------------------------------------------------
// MARK: - NSViewController extension
extension NSViewController {

	// MARK: Class methods
	//------------------------------------------------------------------------------------------------------------------
	@objc static func addReplacement(from fromString :String, to toString :String) {
		// Add
		sReplacements.append((fromString, toString))
	}

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	func presentAlert(with alertStyle :NSAlert.Style, message :String, information :String, buttonTitles :[String],
			completion:@escaping (_ modalResponse :NSApplication.ModalResponse) -> Void = { _ in }) {
		// Setup
		let	alert = NSAlert()
		alert.alertStyle = alertStyle
		alert.messageText = message.applying(sReplacements)
		alert.informativeText = information.applying(sReplacements)
		buttonTitles.forEach() { alert.addButton(withTitle: $0) }

		// Present
		alert.beginSheetModal(for: self.view.window!, completionHandler: completion)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func presentInformationalAlert(message :String, information :String, buttonTitles :[String],
			completion:@escaping (_ modalResponse :NSApplication.ModalResponse) -> Void = { _ in }) {
		// Present alert
		presentAlert(with: .informational, message: message, information: information, buttonTitles: buttonTitles,
				completion: completion)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func presentWarningAlert(message :String, information :String, buttonTitles :[String],
			completion:@escaping (_ modalResponse :NSApplication.ModalResponse) -> Void = { _ in }) {
		// Present alert
		presentAlert(with: .warning, message: message, information: information, buttonTitles: buttonTitles,
				completion: completion)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func presentCriticalAlert(message :String, information :String, buttonTitles :[String],
			completion:@escaping (_ modalResponse :NSApplication.ModalResponse) -> Void = { _ in }) {
		// Present alert
		presentAlert(with: .critical, message: message, information: information, buttonTitles: buttonTitles,
				completion: completion)
	}
}

//----------------------------------------------------------------------------------------------------------------------
// MARK: - String extension
fileprivate extension String {

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	func applying(_ replacements :[(fromString :String, toString :String)]) -> String {
		// Setup
		var	string = self

		// Apply replacements
		replacements.forEach() { string = string.replacingOccurrences(of: $0.fromString, with: $0.toString) }

		return string
	}
}
