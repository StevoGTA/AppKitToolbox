//
//  NSOutlineView+Extensions.swift
//  Media Tools
//
//  Created by Stevo on 9/28/20.
//  Copyright © 2020 Stevo Brock. All rights reserved.
//

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSOutlineView extension
extension NSOutlineView {

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	func select(_ item :Any? = nil) { select(row(forItem: item)) }
}
