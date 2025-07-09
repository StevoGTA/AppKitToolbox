//----------------------------------------------------------------------------------------------------------------------
//	NSFont+Extensions.swift			©2025 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSFont extension
public extension NSFont {

	// MARK: Properties
	@objc	var	normalVariation :NSFont { NSFontManager.shared.convert(self, toNotHaveTrait: .italicFontMask) }
	@objc	var	italicVariation :NSFont { NSFontManager.shared.convert(self, toHaveTrait: .italicFontMask) }
}
