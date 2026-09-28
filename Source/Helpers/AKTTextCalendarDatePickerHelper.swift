//----------------------------------------------------------------------------------------------------------------------
//	AKTTextCalendarDatePickerHelper.swift			©2025 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTextCalendarDatePickerHelper
@MainActor
class AKTTextCalendarDatePickerHelper : NSObject {

	// MARK: Properties
	@objc(dateValue)
				var	date :Date {
							get { self.textDatePicker.dateValue }
							set {
								// Update
								self.textDatePicker.dateValue = newValue
								self.calendarDatePicker.dateValue = newValue
							}
						}

	@objc		var	actionProc :() -> Void = {}
	@objc		var	updateLayoutProc :() -> Void = {}

	@IBOutlet	var	textDatePicker :NSDatePicker!
	@IBOutlet	var	calendarDatePicker :NSDatePicker!
	@IBOutlet	var	segmentedControl :NSSegmentedControl!

	@IBOutlet	var	textDatePickerBottomConstraint :NSLayoutConstraint?
	@IBOutlet	var	calendarDatePickerBottomConstraint :NSLayoutConstraint?

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc func setup() {
		// Setup
		self.textDatePicker?.actionProc = { [unowned self] _ in
			// Update the other one
			self.calendarDatePicker.dateValue = self.textDatePicker.dateValue

			// Call action proc
			self.actionProc()
		}
		self.calendarDatePicker?.actionProc = { [unowned self] _ in
			// Update the other one
			self.textDatePicker.dateValue = self.calendarDatePicker.dateValue

			// Call action proc
			self.actionProc()
		}
		self.segmentedControl?.actionProc = { [unowned self] _ in
			// Update UI
			self.textDatePicker.set(isHidden: self.segmentedControl.selectedSegment != 0, animated: true)
			self.calendarDatePicker.set(isHidden: self.segmentedControl.selectedSegment != 1, animated: true)

			// Update Layout
			self.updateLayoutProc()
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	func set(datePickerElements :NSDatePicker.ElementFlags) {
		// Set
		self.textDatePicker.datePickerElements = datePickerElements
		self.calendarDatePicker.datePickerElements = datePickerElements
	}

	//------------------------------------------------------------------------------------------------------------------
	// Swift 6.1 (Xcode 16.4) prints NS_OPTIONS parameter types by their bare Swift name in the generated header when
	//	C++ interop is enabled, so the Objective-C selector takes the raw value.  Remove once on Swift 6.2 or later.
	@objc(setDatePickerElements:)
	func set(datePickerElementsRawValue :UInt) {
		// Set
		set(datePickerElements: NSDatePicker.ElementFlags(rawValue: datePickerElementsRawValue))
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(setHidden:segmentedControlIsHidden:animated:)
	func set(isHidden :Bool, segmentedControlIsHidden :Bool, animated :Bool = false) {
		// Update UI
		self.textDatePicker.set(isHidden: isHidden || (self.segmentedControl.selectedSegment != 0), animated: animated)
		self.calendarDatePicker.set(isHidden: isHidden || (self.segmentedControl.selectedSegment != 1),
				animated: animated)
		self.segmentedControl.set(isHidden: segmentedControlIsHidden, animated: animated)

		// Update layout
		updateLayout()
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc
	func updateLayout() {
		// Check if have layout constraints
		guard let textDatePickerBottomConstraint = self.textDatePickerBottomConstraint,
				let calendarDatePickerBottomConstraint = self.calendarDatePickerBottomConstraint else { return }

		// Check visibility
		if self.calendarDatePicker.isHidden {
			// Use text setup
			NSLayoutConstraint.deactivate([calendarDatePickerBottomConstraint])
			NSLayoutConstraint.activate([textDatePickerBottomConstraint])
		} else {
			// Use calendar setup
			NSLayoutConstraint.deactivate([textDatePickerBottomConstraint])
			NSLayoutConstraint.activate([calendarDatePickerBottomConstraint])
		}
	}
}
