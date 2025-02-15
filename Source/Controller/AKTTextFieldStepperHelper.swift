//----------------------------------------------------------------------------------------------------------------------
//	AKTTextFieldStepperHelper.swift			©2025 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTextFieldStepperHelper
public class AKTTextFieldStepperHelper : NSObject {

	// MARK: Properties
	@objc	public		var	value :Int {
									get { self.stepper.integerValue }
									set {
										// Update UI
										self.textField.stringValue = "\(newValue)"
										self.stepper.integerValue = newValue
									}
								}

			@IBOutlet	var	textField :AKTTextField! {
									didSet {
										// Setup
										self.textField.formatter = MultiFormatter(allowedCharacterSet: .decimalDigits)
										self.textField.textDidChangeProc = { [unowned self] _ in
											// Update UI
											self.stepper.integerValue = self.textField.integerValue
										}
									}
								}
			@IBOutlet	var	stepper :NSStepper! {
									didSet {
										// Setup
										self.stepper.actionProc = { [unowned self] in
											// Update UI
											self.textField.stringValue = "\($0.integerValue)"
										}
									}
								}

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc public func setFormatter(_ formatter :Formatter) { self.textField.formatter = formatter }
}
