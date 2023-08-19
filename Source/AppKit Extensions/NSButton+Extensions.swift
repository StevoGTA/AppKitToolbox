//
//  NSButton+Extensions.swift
//  AppKit Toolbox
//
//  Created by Stevo on 8/18/23.
//

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSButton extension
extension NSButton {

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	@objc convenience init(title :String, actionProc :@escaping (_ button :NSButton) -> Void) {
		// Do super
		self.init(title: title, target: nil, action: nil)

		// Set action
		self.actionProc = { actionProc($0 as! NSButton) }
	}
}
