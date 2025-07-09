//----------------------------------------------------------------------------------------------------------------------
//	NSAlert+Extensions.swift			©2023 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: Local data
var	sGlobalReplacements = [(fromString :String, toString :String)]()

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSAlert extensions
extension NSAlert {

	@objc(NSAlertInfo) class Info : NSObject {

		// MARK: Properties
		@objc	let	alert :NSAlert
		@objc	let	completion :(_ modalResponse :NSApplication.ModalResponse) -> Void

		// MARK: Class methods
		//--------------------------------------------------------------------------------------------------------------
		@objc static func with(alert :NSAlert,
				completion :@escaping (_ modalResponse :NSApplication.ModalResponse) -> Void) -> Info {
			// Return info
			return Info(alert: alert, completion: completion)
		}

		//--------------------------------------------------------------------------------------------------------------
		@objc static func with(alert :NSAlert) -> Info {
			// Return info
			return Info(alert: alert, completion: { _ in })
		}

		// MARK: Lifecycle methods
		//--------------------------------------------------------------------------------------------------------------
		init(alert :NSAlert, completion :@escaping (_ modalResponse :NSApplication.ModalResponse) -> Void) {
			// Store
			self.alert = alert
			self.completion = completion
		}
	}

	// MARK: Class methods
	//------------------------------------------------------------------------------------------------------------------
	@objc static func addGlobalReplacement(from fromString :String, to toString :String) {
		// Add
		sGlobalReplacements.append((fromString, toString))
	}

	//------------------------------------------------------------------------------------------------------------------
	static func with(style :Style, message :String, information :String, buttonTitles :[String]) ->
			NSAlert {
		// Return NSAlert
		return NSAlert(style: style, message: message, information: information, buttonTitles: buttonTitles)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc static func informational(message :String, information :String, buttonTitles :[String]) -> NSAlert {
		// Return NSAlert
		return NSAlert(style: .informational, message: message, information: information, buttonTitles: buttonTitles)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc static func warning(message :String, information :String, buttonTitles :[String]) -> NSAlert {
		// Return NSAlert
		return NSAlert(style: .warning, message: message, information: information, buttonTitles: buttonTitles)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc static public func critical(message :String, information :String, buttonTitles :[String]) -> NSAlert {
		// Return NSAlert
		return NSAlert(style: .critical, message: message, information: information, buttonTitles: buttonTitles)
	}

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	convenience init(style :Style, message :String, information :String, buttonTitles :[String]) {
		// Do super
		self.init()

		// Setup
		self.alertStyle = alertStyle
		self.messageText = message.applying(sGlobalReplacements)
		self.informativeText = information.applying(sGlobalReplacements)
		buttonTitles.forEach() { self.addButton(withTitle: $0) }
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
