//----------------------------------------------------------------------------------------------------------------------
//	AKTTextFieldStepperHelper.swift			©2025 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTextFieldStepperHelper
public class AKTTextFieldStepperHelper : NSObject {

	// MARK: Properties
	@objc(integerValue)
	public		var	intValue :Int {
							get { self.stepper.integerValue }
							set {
								// Update UI
								self.textField.stringValue = self.stringForValueProc(Double(newValue))
								self.stepper.integerValue = newValue
							}
						}
	@objc
	public		var	doubleValue :Double {
							get { self.stepper.doubleValue }
							set {
								// Update UI
								self.textField.stringValue = self.stringForValueProc(newValue)
								self.stepper.doubleValue = newValue
							}
						}
	@objc
	public		var	doubleMinValue :Double {
							get { self.stepper.minValue }
							set { self.stepper.minValue = newValue }
						}

	@objc
	public		var	doubleMaxValue :Double {
							get { self.stepper.maxValue }
							set { self.stepper.maxValue = newValue }
						}

	@objc(hidden)
	public		var	isHidden :Bool {
							get { self.textField!.isHidden }
							set {
								// Update UI
								self.textField!.isHidden = newValue
								self.stepper!.isHidden = newValue
							}
						}
	@objc
	public		var	isValid :Bool {
							// Get value
							let	value = self.valueForStringProc(self.textField.stringValue)

							return !self.textField.isEmpty && (value >= self.stepper.minValue) &&
									(value <= self.stepper.maxValue)
						}

	@objc
	public		var	stringForValueProc :(_ value :Double) -> String = { "\($0)" }

	@objc
	public		var	valueForStringProc :(_ string :String) -> Double = { Double($0) ?? 0.0 }

	@objc
				var	actionProc :(_ valueIsValid :Bool) -> Void = { _ in }

	@IBOutlet	var	textField :AKTTextField! {
							didSet {
								// Setup
								self.textField.formatter = MultiFormatter(allowedCharacterSet: .decimalDigits)
								self.textField.didChangeProc = { [unowned self] in
									// Get value
									let	value = self.valueForStringProc($0)
									let	isValid =
												!$0.isEmpty && (value >= self.stepper.minValue) &&
														(value <= self.stepper.maxValue)

									// Update UI
									self.textField.isValueValid = isValid
									self.stepper.doubleValue = value

									// Call action proc
									self.actionProc(isValid)
								}
								self.textField.didEndEditingProc = { [unowned self] in
									// Setup
									let	value = self.valueForStringProc($0)

									// Update UI
									self.textField.isValueValid = true
									self.textField.stringValue = self.stringForValueProc(value)

									self.stepper.doubleValue = value

									// Call action proc
									self.actionProc(true)
								}
							}
						}
	@IBOutlet	var	stepper :NSStepper! {
							didSet {
								// Setup
								self.stepper.actionProc = { [unowned self] in
									// Update UI
									self.textField.stringValue = self.stringForValueProc($0.doubleValue)
									self.textField.isValueValid = true

									// Call action proc
									self.actionProc(true)
								}
							}
						}

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc(setFormatter:)
	public func set(formatter :Formatter) { self.textField.formatter = formatter }

	//------------------------------------------------------------------------------------------------------------------
	@objc(setDoubleMinValue:maxValue:)
	public func set(minValue :Double, maxValue :Double) {
		// Setup
		self.stepper.minValue = minValue
		self.stepper.maxValue = maxValue
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(setIntegerMinValue:maxValue:)
	public func set(minValue :Int, maxValue :Int) {
		// Setup
		self.stringForValueProc = { "\(Int($0))" }
		self.stepper.minValue = Double(minValue)
		self.stepper.maxValue = Double(maxValue)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(setHidden:animated:)
	public func set(isHidden :Bool, animated :Bool = false) {
		// Update UI
		self.textField.set(isHidden: isHidden, animated: animated)
		self.stepper.set(isHidden: isHidden, animated: animated)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(setEnabled:animated:)
	public func set(isEnabled :Bool, animated :Bool = false) {
		// Update UI
		self.textField.set(isEnabled: isEnabled, animated: animated)
		self.stepper.set(isEnabled: isEnabled, animated: animated)
	}
}
