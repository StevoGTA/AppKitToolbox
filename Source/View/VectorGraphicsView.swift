//----------------------------------------------------------------------------------------------------------------------
//	VectorGraphicsView.swift			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: VectorGraphicsView
public class VectorGraphicsView : NSView {

	// MARK: Content
	public enum Content {
		case color(color :NSColor)
		case oval(color :NSColor)
		case shape(path :NSBezierPath, color :NSColor)
	}

	// MARK: Properties
	public	var	content :Content?

	// MARK: NSView methods
	//------------------------------------------------------------------------------------------------------------------
	override public func draw(_ dirtyRect :NSRect) {
		// Check if have content
		guard let content = self.content else { return }

		// Check content
		switch content {
			case let .color(color):
				// Color
				color.set()
				dirtyRect.fill()

			case let .oval(color: color):
				// Oval
				color.set()
				NSBezierPath(ovalIn: self.bounds).fill()

			case let .shape(path, color):
				// Shape
				color.set()
				path.fill()
		}
	}
}
