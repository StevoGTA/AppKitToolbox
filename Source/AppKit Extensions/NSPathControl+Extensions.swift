//
//  NSPathControl+Extensions.swift
//  AppKit Toolbox
//
//  Created by Stevo on 11/3/20.
//  Copyright © 2020 Stevo Brock. All rights reserved.
//

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSPathControl extension
public extension NSPathControl {

	// MARK: Properties
	var	file :File? {
				get { File.from(self.url) }
				set { self.url = newValue?.url }
			}
	var	folder :Folder? {
				get { Folder.from(self.url) }
				set { self.url = newValue?.url }
			}
}
