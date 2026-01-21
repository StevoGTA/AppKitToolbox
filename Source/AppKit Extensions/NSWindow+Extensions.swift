//----------------------------------------------------------------------------------------------------------------------
//	NSWindow+Extensions.swift			©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSWindow extension
public extension NSWindow {

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc(presentAlert:completionHandlerWithSuppression:)
	func present(_ alert :NSAlert,
			completionProc :@escaping (_ modalResponse :NSApplication.ModalResponse, _ doNotShowAgain :Bool) -> Void) {
		// Present
		alert.beginSheetModal(for: self) { [unowned alert] in
			// Call proc
			completionProc($0, alert.suppressionButton?.state == .on)
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(presentAlert:completionHandler:)
	func present(_ alert :NSAlert,
			completionProc :@escaping (_ modalResponse :NSApplication.ModalResponse) -> Void = { _ in }) {
		// Present
		alert.beginSheetModal(for: self) { completionProc($0) }
	}
}
