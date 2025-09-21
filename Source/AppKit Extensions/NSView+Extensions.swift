//----------------------------------------------------------------------------------------------------------------------
//	NSView+Extensions.swift			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSView extension
public extension NSView {

	// MARK: Properties
	@objc	var aktBackgroundColor :NSColor? {
						get {
							// Retrieve color
							guard let color = layer?.backgroundColor else { return nil }

							return NSColor(cgColor: color)
						}
						set {
							// Update
							self.wantsLayer = true
							self.layer?.backgroundColor = newValue?.cgColor
						}
					}

	// MARK: Constraint methods
	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc
	func match(_ view :NSView, activate :Bool = true) -> [NSLayoutConstraint] {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraints =
					[
						self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
						self.centerYAnchor.constraint(equalTo: view.centerYAnchor),
						self.widthAnchor.constraint(equalTo: view.widthAnchor),
						self.heightAnchor.constraint(equalTo: view.heightAnchor),
					]

		// Check if need to activate
		if activate { NSLayoutConstraint.activate(constraints) }

		return constraints
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc
	func center(in view :NSView, activate :Bool = true) -> [NSLayoutConstraint] {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraints =
					[
						self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
						self.centerYAnchor.constraint(equalTo: view.centerYAnchor),
					]

		// Check if need to activate
		if activate { NSLayoutConstraint.activate(constraints) }

		return constraints
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc
	func match(widthOf view :NSView, activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.widthAnchor.constraint(equalTo: view.widthAnchor)

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc
	func match(heightOf view :NSView, activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.heightAnchor.constraint(equalTo: view.heightAnchor)

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc
	func match(sizeOf view :NSView, activate :Bool = true) -> [NSLayoutConstraint] {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraints =
					[
						self.widthAnchor.constraint(equalTo: view.widthAnchor),
						self.heightAnchor.constraint(equalTo: view.heightAnchor),
					]

		// Check if need to activate
		if activate { NSLayoutConstraint.activate(constraints) }

		return constraints
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc
	func alignLeading(to view :NSView, constant :CGFloat = 0.0, activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant)

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc
	func alignLeading(to view :NSView, constant :CGFloat = 0.0, priority :NSLayoutConstraint.Priority,
			activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant)
		constraint.priority = priority

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc
	func alignTrailing(to view :NSView, constant :CGFloat = 0.0, activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant)

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc
	func alignTrailing(to view :NSView, constant :CGFloat = 0.0, priority :NSLayoutConstraint.Priority,
			activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant)
		constraint.priority = priority

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc(alignTrailingGreaterThanEqualTo:constant:activate:)
	func alignTrailing(greaterThanOrEqualTo view :NSView, constant :CGFloat = 0.0, activate :Bool = true) ->
			NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: constant)

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc(alignTrailingGreaterThanEqualTo:constant:priority:activate:)
	func alignTrailing(greaterThanOrEqualTo view :NSView, constant :CGFloat = 0.0,
			priority :NSLayoutConstraint.Priority, activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: constant)
		constraint.priority = priority

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc(alignTrailingLessThanEqualTo:constant:activate:)
	func alignTrailing(lessThanOrEqualTo view :NSView, constant :CGFloat = 0.0, activate :Bool = true) ->
			NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: constant)

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc(alignTrailingLessThanEqualTo:constant:priority:activate:)
	func alignTrailing(lessThanOrEqualTo view :NSView, constant :CGFloat = 0.0,
			priority :NSLayoutConstraint.Priority, activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: constant)
		constraint.priority = priority

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc
	func alignTop(to view :NSView, constant :CGFloat = 0.0, activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.topAnchor.constraint(equalTo: view.topAnchor, constant: constant)

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc
	func alignTop(to view :NSView, constant :CGFloat = 0.0, priority :NSLayoutConstraint.Priority,
			activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.topAnchor.constraint(equalTo: view.topAnchor, constant: constant)
		constraint.priority = priority

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc
	func alignCenterX(to view :NSView, constant :CGFloat = 0.0, activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant)

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc
	func alignCenterX(to view :NSView, constant :CGFloat = 0.0, priority :NSLayoutConstraint.Priority,
			activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant)
		constraint.priority = priority

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc
	func alignCenterY(to view :NSView, constant :CGFloat = 0.0, activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant)

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc
	func alignCenterY(to view :NSView, constant :CGFloat = 0.0, priority :NSLayoutConstraint.Priority,
			activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant)
		constraint.priority = priority

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc
	func alignBottom(to view :NSView, constant :CGFloat = 0.0, activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: constant)

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc
	func alignBottom(to view :NSView, constant :CGFloat = 0.0, priority :NSLayoutConstraint.Priority,
			activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: constant)
		constraint.priority = priority

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc
	func spaceHorizontally(from view :NSView, constant :CGFloat = 0.0, activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant)

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc
	func spaceHorizontally(from view :NSView, constant :CGFloat = 0.0, priority :NSLayoutConstraint.Priority,
			activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant)
		constraint.priority = priority

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc
	func spaceVertically(from view :NSView, constant :CGFloat = 0.0, activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.topAnchor.constraint(equalTo: view.bottomAnchor, constant: constant)

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc
	func spaceVertically(from view :NSView, constant :CGFloat = 0.0, priority :NSLayoutConstraint.Priority,
			activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.topAnchor.constraint(equalTo: view.bottomAnchor, constant: constant)
		constraint.priority = priority

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc(constrainWidthToMaximum:priority:activate:)
	func constrain(widthToMaximum value :CGFloat, priority :NSLayoutConstraint.Priority, activate :Bool = true) ->
			NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint =
					NSLayoutConstraint(item: self, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil,
							attribute: .notAnAttribute, multiplier: 1.0, constant: value)
		constraint.priority = priority

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc(constrainWidthToMaximum:activate:)
	func constrain(widthToMaximum value :CGFloat, activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint =
					NSLayoutConstraint(item: self, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil,
							attribute: .notAnAttribute, multiplier: 1.0, constant: value)

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc(constrainWidthToMinimum:priority:activate:)
	func constrain(widthToMinimum value :CGFloat, priority :NSLayoutConstraint.Priority, activate :Bool = true) ->
			NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint =
					NSLayoutConstraint(item: self, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil,
							attribute: .notAnAttribute, multiplier: 1.0, constant: value)
		constraint.priority = priority

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc(constrainWidthToMinimum:activate:)
	func constrain(widthToMinimum value :CGFloat, activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint =
					NSLayoutConstraint(item: self, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil,
							attribute: .notAnAttribute, multiplier: 1.0, constant: value)

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc(constrainHeightToMaximum:priority:activate:)
	func constrain(heightToMaximum value :CGFloat, priority :NSLayoutConstraint.Priority, activate :Bool = true) ->
			NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint =
					NSLayoutConstraint(item: self, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil,
							attribute: .notAnAttribute, multiplier: 1.0, constant: value)
		constraint.priority = priority

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc(constrainHeightToMaximum:activate:)
	func constrain(heightToMaximum value :CGFloat, activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint =
					NSLayoutConstraint(item: self, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil,
							attribute: .notAnAttribute, multiplier: 1.0, constant: value)

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc(constrainHeightToMinimum:priority:activate:)
	func constrain(heightToMinimum value :CGFloat, priority :NSLayoutConstraint.Priority, activate :Bool = true) ->
			NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint =
					NSLayoutConstraint(item: self, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil,
							attribute: .notAnAttribute, multiplier: 1.0, constant: value)
		constraint.priority = priority

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc(constrainHeightToMinimum:activate:)
	func constrain(heightToMinimum value :CGFloat, activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint =
					NSLayoutConstraint(item: self, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil,
							attribute: .notAnAttribute, multiplier: 1.0, constant: value)

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	func constraints(between view1 :NSView, and view2 :NSView) -> [NSLayoutConstraint] {
		// Filter all constraints
		return self.constraints.filter(
				{ (($0.firstItem === view1) && ($0.secondItem === view2)) ||
						(($0.firstItem === view2) && ($0.secondItem === view1)) })
	}

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc(setEnabled:animated:)
	func set(isEnabled :Bool, animated :Bool = false) {
		// Iterate subviews
		self.subviews.forEach() {
			// Check if is NSControl
			if let control = $0 as? NSControl {
				// Update enabled
				if animated {
					// Animated
					control.animator().isEnabled = isEnabled
				} else {
					// Not animated
					control.isEnabled = isEnabled
				}
			} else {
				// Assume NSView
				$0.set(isEnabled: isEnabled, animated: animated)
			}
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(setHidden:animated:)
	func set(isHidden :Bool, animated :Bool = false) {
		// Check animated
		if animated {
			// Animated
			self.animator().isHidden = isHidden
		} else {
			// Not animated
			self.isHidden = isHidden
		}
	}
}
