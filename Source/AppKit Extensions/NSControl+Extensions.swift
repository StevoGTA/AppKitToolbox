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
	@objc var	actionProc :ActionProc {
						get { (objc_getAssociatedObject(index, "actionProc") as! ActionProcObject).actionProc }
						set {
							// Setup
							let	actionProcObject = ActionProcObject(newValue)
							objc_setAssociatedObject(self, "actionProc", actionProcObject,
									.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

							self.action = #selector(ActionProcObject.callActionProc(_:))
							self.target = actionProcObject
						}
					}

	// MARK: ActionProcObject
	@objc class ActionProcObject : NSObject {

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
