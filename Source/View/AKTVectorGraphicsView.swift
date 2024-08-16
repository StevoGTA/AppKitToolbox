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
		case filledPill(color :NSColor)
		case strokedPill(color :NSColor, lineWidth :CGFloat = 1.0)
		case filledAndStrokedPill(fillColor :NSColor, strokeColor :NSColor, lineWidth :CGFloat = 1.0)
		case filledRoundedRect(color :NSColor, radius :CGFloat = 10.0)
		case strokedRoundedRect(color :NSColor, radius :CGFloat = 10.0, lineWidth :CGFloat = 1.0)
		case filledShape(path :NSBezierPath, color :NSColor)
		case strokedShape(path :NSBezierPath, color :NSColor)
	}

	// MARK: Properties
	public	var	content :Content? { didSet { self.needsDisplay = true } }

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

			case let .filledPill(color: color):
				// Pill
				color.setFill()

				let	radius = min(self.bounds.size.width, self.bounds.size.height) / 2.0
				NSBezierPath(roundedRect: self.bounds, xRadius: radius, yRadius: radius).fill()

			case let .strokedPill(color: color, lineWidth: lineWidth):
				// Pill
				color.setStroke()

				let	rect = self.bounds.insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
				let	radius = min(rect.size.width, rect.size.height) / 2.0
				let	path = NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
				path.lineWidth = lineWidth
				path.stroke()

			case let .filledAndStrokedPill(fillColor: fillColor, strokeColor: strokeColor, lineWidth: lineWidth):
				// Pill
				fillColor.setFill()
				strokeColor.setStroke()

				let	fillRadius = min(self.bounds.size.width, self.bounds.size.height) / 2.0

				NSBezierPath(roundedRect: self.bounds, xRadius: fillRadius, yRadius: fillRadius).fill()

				let	rect = self.bounds.insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
				let	strokeRadius = min(rect.size.width, rect.size.height) / 2.0
				let	path = NSBezierPath(roundedRect: rect, xRadius: strokeRadius, yRadius: strokeRadius)
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

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc func setContent(_ color :NSColor) { self.content = .color(color) }

	//------------------------------------------------------------------------------------------------------------------
	@objc (setContentAsOvalFilledWithColor:)
	func setContent(filledOvalWithColor color :NSColor) {
		// Set content
		self.content = .filledOval(color: color)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc (setContentAsOvalStrokedWithColor:lineWidth:)
	func setContent(strokedOvalWithColor color :NSColor, lineWidth :CGFloat = 1.0) {
		// Set content
		self.content = .strokedOval(color: color, lineWidth: lineWidth)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc (setContentAsPillFilledWithColor:)
	func setContent(filledPillWithColor color :NSColor) {
		// Set content
		self.content = .filledPill(color: color)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc (setContentAsPillStrokedWithColor:lineWidth:)
	func setContent(strokedPillWithColor color :NSColor, lineWidth :CGFloat = 1.0) {
		// Set content
		self.content = .strokedPill(color: color, lineWidth: lineWidth)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc (setContentAsPillFilledWithColor:strokedWithColor:lineWidth:)
	func setContentAsPill(filledWithColor fillColor :NSColor, strokedWithColor strokeColor :NSColor,
			lineWidth :CGFloat = 1.0) {
		// Set content
		self.content = .filledAndStrokedPill(fillColor: fillColor, strokeColor: strokeColor, lineWidth: lineWidth)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc (setContentAsRoundedRectFilledWithColor:radius:)
	func setContent(filledRoundedRectWithColor color :NSColor, radius :CGFloat = 10.0) {
		// Set content
		self.content = .filledRoundedRect(color: color, radius: radius)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc (setContentAsRoundedRectStrokedWithColor:radius:lineWidth:)
	func setContent(strokedRoundedRectWithColor color :NSColor, radius :CGFloat = 10.0,
			lineWidth :CGFloat = 1.0) {
		// Set content
		self.content = .strokedRoundedRect(color: color, radius: radius, lineWidth: lineWidth)
	}
	//------------------------------------------------------------------------------------------------------------------
	@objc (setContentAsShapeFilledWithPath:color:)
	func setContent(filledShapeWithPath path :NSBezierPath, color :NSColor) {
		// Set content
		self.content = .filledShape(path: path, color: color)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc (setContentAsShapeStrokedWithPath:color:)
	func setContent(strokedShapeWithPath path :NSBezierPath, color :NSColor) {
		// Set content
		self.content = .strokedShape(path: path, color: color)
	}
}
