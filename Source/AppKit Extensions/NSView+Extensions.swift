//
//  NSView+Extensions.swift
//  Sound Grinder
//
//  Created by Stevo on 5/28/21.
//

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSView extension
extension NSView {

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
	func alignLeading(to view :NSView, constant :CGFloat = 0.0, priority :NSLayoutConstraint.Priority? = nil,
			activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant)
		if priority != nil { constraint.priority = priority! }

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	func alignTrailing(to view :NSView, constant :CGFloat = 0.0, priority :NSLayoutConstraint.Priority? = nil,
			activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant)
		if priority != nil { constraint.priority = priority! }

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	func alignTop(to view :NSView, constant :CGFloat = 0.0, priority :NSLayoutConstraint.Priority? = nil,
			activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.topAnchor.constraint(equalTo: view.topAnchor, constant: constant)
		if priority != nil { constraint.priority = priority! }

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	func alignCenterX(to view :NSView, constant :CGFloat = 0.0, priority :NSLayoutConstraint.Priority? = nil,
			activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant)
		if priority != nil { constraint.priority = priority! }

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	func alignCenterY(to view :NSView, constant :CGFloat = 0.0, priority :NSLayoutConstraint.Priority? = nil,
			activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant)
		if priority != nil { constraint.priority = priority! }

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	func alignBottom(to view :NSView, constant :CGFloat = 0.0, priority :NSLayoutConstraint.Priority? = nil,
			activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: constant)
		if priority != nil { constraint.priority = priority! }

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	func spaceHorizontally(from view :NSView, constant :CGFloat = 0.0, priority :NSLayoutConstraint.Priority? = nil,
			activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant)
		if priority != nil { constraint.priority = priority! }

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	func spaceVertically(from view :NSView, constant :CGFloat = 0.0, priority :NSLayoutConstraint.Priority? = nil,
			activate :Bool = true) -> NSLayoutConstraint {
		// Setup
		self.translatesAutoresizingMaskIntoConstraints = false

		let	constraint = self.topAnchor.constraint(equalTo: view.bottomAnchor, constant: constant)
		if priority != nil { constraint.priority = priority! }

		// Check if need to activate
		if activate { NSLayoutConstraint.activate([constraint]) }

		return constraint
	}
}
