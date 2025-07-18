//----------------------------------------------------------------------------------------------------------------------
//	NSPathControl+Extensions.swift			©2020 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

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
