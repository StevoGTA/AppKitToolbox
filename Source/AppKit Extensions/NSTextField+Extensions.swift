//
//  NSTextField+Extensions.swift
//  AppKit Toolbox
//
//  Created by Stevo on 5/12/23.
//

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSTextField extensions
extension NSTextField {

	// MARK: OnlyFloatValueFormatter
	@objc class OnlyFloatValueFormatter : NumberFormatter, @unchecked Sendable {

		// MARK: NumberFormatter methods
		override func isPartialStringValid(_ partialString :String,
				newEditingString newString :AutoreleasingUnsafeMutablePointer<NSString?>?,
				errorDescription error :AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
			//
			return partialString.isEmpty || (Float(partialString) != nil)
		}
	}
}
