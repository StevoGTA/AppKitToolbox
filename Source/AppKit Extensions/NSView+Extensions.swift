//
//  NSView+Extensions.swift
//  AppKit Toolbox
//
//  Created by Stevo on 5/28/21.
//

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

	// MARK: Instance methods
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
	@objc(alignTrailingEqualTo:constant:activate:)
	func alignTrailing(equalTo view :NSView, constant :CGFloat = 0.0, activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant)

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc(alignTrailingEqualTo:constant:priority:activate:)
	func alignTrailing(equalTo view :NSView, constant :CGFloat = 0.0, priority :NSLayoutConstraint.Priority,
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
}
