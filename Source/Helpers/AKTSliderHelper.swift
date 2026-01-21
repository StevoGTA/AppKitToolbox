//----------------------------------------------------------------------------------------------------------------------
//	AKTSliderHelper.swift			©2025 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTSliderHelper
@MainActor
class AKTSliderHelper : NSObject {

	// MARK: Properties
	@objc		var	integerValue :Int {
							get { self.slider.integerValue }
							set { self.slider.integerValue = newValue }
						}

	@IBOutlet	var	leadingLabel :NSTextField?
	@IBOutlet	var	slider :NSSlider!
	@IBOutlet	var	trailingLabel :NSTextField?

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc(setHidden:animated:)
	func set(isHidden :Bool, animated :Bool = false) {
		// Update UI
		self.leadingLabel?.set(isHidden: isHidden, animated: animated)
		self.slider.set(isHidden: isHidden, animated: animated)
		self.trailingLabel?.set(isHidden: isHidden, animated: animated)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(setEnabled:animated:)
	func set(isEnabled :Bool, animated :Bool = false) {
		// Update UI
		self.leadingLabel?.set(isEnabled: isEnabled, animated: animated)
		self.slider.set(isEnabled: isEnabled, animated: animated)
		self.trailingLabel?.set(isEnabled: isEnabled, animated: animated)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(setIntegerValue:animatd:)
	func set(integerValue :Int, animated :Bool = false) {
		// Update UI
		self.slider.set(integerValue: integerValue, animated: animated)
	}
}
