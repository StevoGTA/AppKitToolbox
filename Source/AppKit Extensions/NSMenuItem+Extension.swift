//
//  NSMenuItem+Extension.swift
//  AppKit Toolbox
//
//  Created by Stevo on 3/18/24.
//  Copyright © 2024 Stevo Brock. All rights reserved.
//

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSMenuItem extension
public extension NSMenuItem {

	// MARK: Types
	typealias ActionProc = (_ item :NSMenuItem) -> Void

	// MARK: Properties
	static			private	var	actionProcKey :Void?

			@objc			var	actionProc :ActionProc {
										get { (objc_getAssociatedObject(self, &NSMenuItem.actionProcKey) as!
												NSMenuItemActionProcObject).actionProc }
										set {
											// Setup
											let	actionProcObject = NSMenuItemActionProcObject(newValue)
											objc_setAssociatedObject(self, &NSMenuItem.actionProcKey, actionProcObject,
													.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

											self.action = #selector(NSMenuItemActionProcObject.callActionProc(_:))
											self.target = actionProcObject
										}
									}

	// MARK: NSMenuItemActionProcObject
	@objc class NSMenuItemActionProcObject : NSObject {

		// MARK: Properties
		let	actionProc :ActionProc

		// MARK: Lifecycle methods
		//--------------------------------------------------------------------------------------------------------------
		init(_ actionProc :@escaping ActionProc) {
			// Store
			self.actionProc = actionProc
		}

		// MARK: Instance methods
		//--------------------------------------------------------------------------------------------------------------
		@objc func callActionProc(_ sender :NSMenuItem) { self.actionProc(sender) }
	}
}
