//
//  AKTViewController.swift
//  Media Tools
//
//  Created by Stevo on 9/28/20.
//  Copyright © 2020 Stevo Brock. All rights reserved.
//

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTViewController
class AKTViewController : NSViewController {

	// MARK: Properties
	private	var	notificationObservers = [NSObjectProtocol]()

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	deinit {
		// Cleanup
		self.notificationObservers.forEach() { NotificationCenter.default.removeObserver($0) }
	}

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	func addNotificationObserver(forName name :NSNotification.Name, object :Any? = nil, queue :OperationQueue? = nil,
			proc :@escaping (Notification) -> Void) {
		// Add
		self.notificationObservers.append(
				NotificationCenter.default.addObserver(forName: name, object: object, queue: queue, using: proc))
	}
}
