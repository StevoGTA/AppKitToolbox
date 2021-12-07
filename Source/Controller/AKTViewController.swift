//
//  AKTViewController.swift
//  AppKit Toolbox
//
//  Created by Stevo on 9/28/20.
//  Copyright © 2020 Stevo Brock. All rights reserved.
//

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTViewController
open class AKTViewController : NSViewController {

	// MARK: Properties
	private	var	presentErrorCompletionProc :(() -> Void)? = nil
	private	var	notificationObservers = [NSObjectProtocol]()

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	deinit {
		// Cleanup
		self.notificationObservers.forEach() { NotificationCenter.default.removeObserver($0) }
	}

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	public func presentAlert(style :NSAlert.Style = .warning, message :String? = nil, information :String? = nil,
			buttonTitles :[String]? = nil,
			completionProc :@escaping (_ modalResponse :NSApplication.ModalResponse) -> Void = { _ in }) {
		// Setup
		let	alert = NSAlert()
		alert.alertStyle = style
		alert.messageText = message ?? ""
		alert.informativeText = information ?? ""
		buttonTitles?.forEach() { alert.addButton(withTitle: $0) }

		// Present
		alert.beginSheetModal(for: self.view.window!) { completionProc($0) }
	}

	//------------------------------------------------------------------------------------------------------------------
	public func present(error :Error, completionProc :@escaping() -> Void = {}) {
		// Store
		self.presentErrorCompletionProc = completionProc

		// Present error
		presentError(error, modalFor: self.view.window!, delegate: self,
				didPresent: #selector(didPresentError(didRecover:contextInfo:)), contextInfo: nil)
	}

	//------------------------------------------------------------------------------------------------------------------
	public func addNotificationObserver(forName name :NSNotification.Name, object :Any? = nil,
			queue :OperationQueue? = nil, proc :@escaping (Notification) -> Void) {
		// Add
		self.notificationObservers.append(
				NotificationCenter.default.addObserver(forName: name, object: object, queue: queue, using: proc))
	}

	// MARK: Private methods
	//------------------------------------------------------------------------------------------------------------------
	@objc private func didPresentError(didRecover :Bool, contextInfo :UnsafeMutableRawPointer?) {
		// Call proc
		self.presentErrorCompletionProc?()
	}
}
