//----------------------------------------------------------------------------------------------------------------------
//	AKTLabel.swift			©2022 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTLabel
public class AKTLabel : NSTextField {

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	public override init(frame frameRect :NSRect) {
		// Do super
		super.init(frame: frameRect)

		// Setup
		self.isBordered = false
		self.drawsBackground = false
		self.isEditable = false
	}

	//------------------------------------------------------------------------------------------------------------------
	public required init?(coder :NSCoder) {
		// Do super
		super.init(coder: coder)

		// Setup
		self.isBordered = false
		self.drawsBackground = false
		self.isEditable = false
	}

	//------------------------------------------------------------------------------------------------------------------
	public init(string :String, font :NSFont? = nil, alignment :NSTextAlignment? = nil, isSelectable :Bool = false) {
		// Do super
		super.init(frame: .zero)

		// Setup
		self.isBordered = false
		self.drawsBackground = false
		self.isEditable = false

		// Store
		self.stringValue = string
		if (font != nil) { self.font = font }
		if (alignment != nil) { self.alignment = alignment! }
		self.isSelectable = isSelectable
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc public init(string :String) {
		// Do super
		super.init(frame: .zero)

		// Setup
		self.isBordered = false
		self.drawsBackground = false
		self.isEditable = false

		// Store
		self.stringValue = string
	}
}
