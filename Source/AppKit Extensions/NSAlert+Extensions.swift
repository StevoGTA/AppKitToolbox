//----------------------------------------------------------------------------------------------------------------------
//	NSAlert+Extensions.swift			©2023 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: Local data

@MainActor
var	sGlobalReplacements = [(fromString :String, toString :String)]()

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSAlert extensions
extension NSAlert {

	// MARK: Info
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
	@objc static func informational(message :String, information :String, buttonTitles :[String]) -> NSAlert {
		// Return NSAlert
		return NSAlert(style: .informational, message: message, information: information, buttonTitles: buttonTitles)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc static func informationalWithSuppressionButton(message :String, information :String, buttonTitles :[String])
			-> NSAlert {
		// Return NSAlert
		return NSAlert(style: .informational, message: message, information: information, buttonTitles: buttonTitles,
				showsSuppressionButton: true)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc static func informational(message :String, information :String, buttonTitles :[String],
			suppressionButtonTitle :String) -> NSAlert {
		// Return NSAlert
		return NSAlert(style: .informational, message: message, information: information, buttonTitles: buttonTitles,
				suppressionButtonTitle: suppressionButtonTitle)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc static func informational(messageKey :String, informationKey :String, buttonTitleKeys :[String],
			localizationTable :String) -> NSAlert {
		// Return NSAlert
		return NSAlert(style: .informational, messageKey: messageKey, informationKey: informationKey,
				buttonTitleKeys: buttonTitleKeys, localizationTable: localizationTable)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc static func informationalWithSuppressionButton(messageKey :String, informationKey :String,
			buttonTitleKeys :[String], localizationTable :String) -> NSAlert {
		// Return NSAlert
		return NSAlert(style: .informational, messageKey: messageKey, informationKey: informationKey,
				buttonTitleKeys: buttonTitleKeys, showsSuppressionButton: true, localizationTable: localizationTable)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc static func informational(messageKey :String, informationKey :String, buttonTitleKeys :[String],
			suppressionButtonTitleKey :String, localizationTable :String) -> NSAlert {
		// Return NSAlert
		return NSAlert(style: .informational, messageKey: messageKey, informationKey: informationKey,
				buttonTitleKeys: buttonTitleKeys, suppressionButtonTitleKey: suppressionButtonTitleKey,
				localizationTable: localizationTable)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc static func warning(message :String, information :String, buttonTitles :[String]) -> NSAlert {
		// Return NSAlert
		return NSAlert(style: .warning, message: message, information: information, buttonTitles: buttonTitles)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc static func warningWithSuppressionButton(message :String, information :String, buttonTitles :[String]) ->
			NSAlert {
		// Return NSAlert
		return NSAlert(style: .warning, message: message, information: information, buttonTitles: buttonTitles,
				showsSuppressionButton: true)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc static func warning(messageKey :String, informationKey :String, buttonTitleKeys :[String],
			localizationTable :String) -> NSAlert {
		// Return NSAlert
		return NSAlert(style: .warning, messageKey: messageKey, informationKey: informationKey,
				buttonTitleKeys: buttonTitleKeys, localizationTable: localizationTable)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc static public func critical(message :String, information :String, buttonTitles :[String]) -> NSAlert {
		// Return NSAlert
		return NSAlert(style: .critical, message: message, information: information, buttonTitles: buttonTitles)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc static func critical(messageKey :String, informationKey :String, buttonTitleKeys :[String],
			localizationTable :String) -> NSAlert {
		// Return NSAlert
		return NSAlert(style: .critical, messageKey: messageKey, informationKey: informationKey,
				buttonTitleKeys: buttonTitleKeys, localizationTable: localizationTable)
	}

	//------------------------------------------------------------------------------------------------------------------
	static public func queryString(message :String, information :String, buttonTitles :[String]) -> String? {
		// Setup
		let	alert = informational(message: message, information: information, buttonTitles: buttonTitles)

		let	textField = NSTextField(frame: NSRect(x: 0.0, y: 0.0, width: 200.0, height: 24.0))
		alert.accessoryView = textField

		// Present
		let	response = alert.runModal()

		return (response == .alertFirstButtonReturn) ? textField.stringValue : nil
	}

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	convenience init(style :Style = .warning, message :String = "", information :String = "",
			buttonTitles :[String] = [], showsSuppressionButton :Bool = false) {
		// Do super
		self.init()

		// Setup
		self.alertStyle = style
		self.messageText = message.applying(sGlobalReplacements)
		self.informativeText = information.applying(sGlobalReplacements)
		buttonTitles.forEach() { self.addButton(withTitle: $0) }
		self.showsSuppressionButton = showsSuppressionButton
	}

	//------------------------------------------------------------------------------------------------------------------
	convenience init(style :Style = .warning, messageKey :String? = nil, informationKey :String? = nil,
			buttonTitleKeys :[String] = [], showsSuppressionButton :Bool = false, localizationTable :String) {
		// Init
		self.init(style: style,
				message:
						(messageKey != nil) ?
								Bundle.main.localizedString(forKey: messageKey!, table: localizationTable) : "",
				information:
						(informationKey != nil) ?
								Bundle.main.localizedString(forKey: informationKey!, table: localizationTable) : "",
				buttonTitles:
						buttonTitleKeys.map({ Bundle.main.localizedString(forKey: $0, table: localizationTable) }),
				showsSuppressionButton: showsSuppressionButton)
	}

	//------------------------------------------------------------------------------------------------------------------
	convenience init(style :Style, message :String, information :String, buttonTitles :[String],
			suppressionButtonTitle :String) {
		// Do super
		self.init()

		// Setup
		self.alertStyle = style
		self.messageText = message.applying(sGlobalReplacements)
		self.informativeText = information.applying(sGlobalReplacements)
		buttonTitles.forEach() { self.addButton(withTitle: $0) }
		self.showsSuppressionButton = true
		self.suppressionButton?.title = suppressionButtonTitle
	}
	//------------------------------------------------------------------------------------------------------------------
	convenience init(style :Style, messageKey :String? = nil, informationKey :String? = nil,
			buttonTitleKeys :[String] = [], suppressionButtonTitleKey :String, localizationTable :String) {
		// Init
		self.init(style: style,
				message:
						(messageKey != nil) ?
								Bundle.main.localizedString(forKey: messageKey!, table: localizationTable) : "",
				information:
						(informationKey != nil) ?
								Bundle.main.localizedString(forKey: informationKey!, table: localizationTable) : "",
				buttonTitles:
						buttonTitleKeys.map({ Bundle.main.localizedString(forKey: $0, table: localizationTable) }),
				suppressionButtonTitle:
						Bundle.main.localizedString(forKey: suppressionButtonTitleKey, table: localizationTable))
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
