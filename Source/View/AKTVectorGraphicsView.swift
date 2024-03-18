//----------------------------------------------------------------------------------------------------------------------
//	AKTVectorGraphicsView.swift			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTVectorGraphicsView
public class AKTVectorGraphicsView : NSView {

	// MARK: Content
	public enum Content {
		case color(_ color :NSColor)
		case filledOval(color :NSColor)
		case strokedOval(color :NSColor, lineWidth :CGFloat = 1.0)
		case filledRoundedRect(color :NSColor, radius :CGFloat = 10.0)
		case strokedRoundedRect(color :NSColor, radius :CGFloat = 10.0, lineWidth :CGFloat = 1.0)
		case filledShape(path :NSBezierPath, color :NSColor)
		case strokedShape(path :NSBezierPath, color :NSColor)
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
				color.setFill()
				dirtyRect.fill()

			case let .filledOval(color: color):
				// Oval
				color.setFill()

				NSBezierPath(ovalIn: self.bounds).fill()

			case let .strokedOval(color: color, lineWidth: lineWidth):
				// Oval
				color.setStroke()

				let	path = NSBezierPath(ovalIn: self.bounds.insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5))
				path.lineWidth = lineWidth
				path.stroke()

			case let .filledRoundedRect(color: color, radius: radius):
				// Oval
				color.setFill()

				NSBezierPath(roundedRect: self.bounds, xRadius: radius, yRadius: radius).fill()

			case let .strokedRoundedRect(color: color, radius: radius, lineWidth: lineWidth):
				// Oval
				color.setStroke()

				let	path =
							NSBezierPath(
									roundedRect: self.bounds.insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5),
											xRadius: radius, yRadius: radius)
				path.lineWidth = lineWidth
				path.stroke()

			case let .filledShape(path, color):
				// Shape
				color.setFill()
				path.fill()

			case let .strokedShape(path, color):
				// Shape
				color.setStroke()
				path.stroke()
		}
	}
}
