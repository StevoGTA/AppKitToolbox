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
}
