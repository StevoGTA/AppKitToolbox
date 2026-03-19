//----------------------------------------------------------------------------------------------------------------------
//	NSViewController+Extensions.swift			©2023 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSViewController extension
public extension NSViewController {

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc(presentAlert:completionHandlerWithSuppression:)
	func present(_ alert :NSAlert,
			completionProc :@escaping (_ modalResponse :NSApplication.ModalResponse, _ doNotShowAgain :Bool) -> Void) {
		// Present
		self.view.window?.present(alert, completionProc: completionProc)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(presentAlert:completionHandler:)
	func present(_ alert :NSAlert, completionProc :@escaping (_ modalResponse :NSApplication.ModalResponse) -> Void) {
		// Present
		self.view.window?.present(alert, completionProc: completionProc)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(presentAlert:)
	func present(_ alert :NSAlert) {
		// Present
		self.view.window?.present(alert, completionProc: { _,_ in })
	}
}
