//
//  NSControl+Extensions.swift
//  AppKit Toolbox
//
//  Created by Stevo on 1/13/23.
//

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSControl extension
extension NSControl {

	// MARK: Types
	typealias ActionProc = (_ control :NSControl) -> Void

	// MARK: Properties
	static			private	var	actionProcKey :Void?

			@objc			var	actionProc :ActionProc {
										get { (objc_getAssociatedObject(self, &NSControl.actionProcKey) as!
												NSControlActionProcObject).actionProc }
										set {
											// Setup
											let	actionProcObject = NSControlActionProcObject(newValue)
											objc_setAssociatedObject(self, &NSControl.actionProcKey, actionProcObject,
													.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

											self.action = #selector(NSControlActionProcObject.callActionProc(_:))
											self.target = actionProcObject
										}
									}

	// MARK: NSControlActionProcObject
	@objc class NSControlActionProcObject : NSObject {

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
		@objc func callActionProc(_ sender :NSControl) { self.actionProc(sender) }
	}
}
