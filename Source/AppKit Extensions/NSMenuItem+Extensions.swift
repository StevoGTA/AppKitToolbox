//----------------------------------------------------------------------------------------------------------------------
//	NSMenuItem+Extensions.swift			©2024 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSMenuItem extension
public extension NSMenuItem {

	// MARK: Types
	typealias ActionProc = (_ menuItem :NSMenuItem) -> Void
	typealias ValidationProc = (_ menuItem :NSMenuItem) -> Bool

	//------------------------------------------------------------------------------------------------------------------
	// MARK: NSMenuItemProcObject
	@objc class NSMenuItemProcObject : NSObject, NSMenuItemValidation {

		// MARK: Properties
		let	actionProc :ActionProc
		let	validationProc :ValidationProc

		// MARK: Lifecycle methods
		//--------------------------------------------------------------------------------------------------------------
		init(validationProc :@escaping ValidationProc = { _ in true }, actionProc :@escaping ActionProc = { _ in }) {
			// Store
			self.actionProc = actionProc
			self.validationProc = validationProc
		}

		// MARK: NSMenuItemValidation methods
		//--------------------------------------------------------------------------------------------------------------
		public func validateMenuItem(_ menuItem :NSMenuItem) -> Bool { self.validationProc(menuItem) }

		// MARK: Instance methods
		//--------------------------------------------------------------------------------------------------------------
		@objc func callActionProc(_ menuItem :NSMenuItem) { self.actionProc(menuItem) }
	}

	// MARK: Properties
	static			private	var	associatedObjectKey :Void?

			@objc			var	actionProc :ActionProc {
										get { (objc_getAssociatedObject(self, &NSMenuItem.associatedObjectKey) as!
												NSMenuItemProcObject).actionProc }
										set {
											// Setup
											let	procObject = NSMenuItemProcObject(actionProc: newValue)
											objc_setAssociatedObject(self, &NSMenuItem.associatedObjectKey, procObject,
													.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

											self.action = #selector(NSMenuItemProcObject.callActionProc(_:))
											self.target = procObject
										}
									}

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc(setValidationProc:actionProc:)
	func set(validationProc :@escaping ValidationProc, actionProc :@escaping ActionProc) {
		// Setup
		let	procObject = NSMenuItemProcObject(validationProc: validationProc, actionProc: actionProc)
		objc_setAssociatedObject(self, &NSMenuItem.associatedObjectKey, procObject,
				.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

		self.action = #selector(NSMenuItemProcObject.callActionProc(_:))
		self.target = procObject
	}
}
