//----------------------------------------------------------------------------------------------------------------------
//	AKTToggleButton.swift			©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTToggleButton
public class AKTToggleButton : NSButton {

	// MARK: Style
	@objc(AKTToggleButtonStyle)
	public enum Style : Int {
		case filled
		case outlined
	}

	// MARK: Properties
	static							private	let	cornerRadius = 6.0
	static							private	let	height = 20.0
	static							private	let	titleInset = 10.0

			@objc					public	var	style = Style.filled { didSet { self.needsDisplay = true } }
			@objc	@IBInspectable	public	var	onColor :NSColor = .controlAccentColor
													{ didSet { self.needsDisplay = true } }
			@objc	@IBInspectable	public	var	borderWidth :CGFloat = 1.0 { didSet { self.needsDisplay = true } }

									private	var	titleFont :NSFont {
														NSFont.systemFont(
																ofSize:
																		self.font?.pointSize ??
																				NSFont.smallSystemFontSize,
																weight: .semibold)
													}

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	public override init(frame frameRect :NSRect) {
		// Do super
		super.init(frame: frameRect)

		// Setup
		setButtonType(.pushOnPushOff)
	}

	//------------------------------------------------------------------------------------------------------------------
	public required init?(coder :NSCoder) {
		// Do super
		super.init(coder: coder)

		// Setup
		setButtonType(.pushOnPushOff)
	}

	// MARK: NSView methods
	//------------------------------------------------------------------------------------------------------------------
	public override var intrinsicContentSize :NSSize {
		// Title plus inset on each side
		NSSize(
				width:
						(self.title as NSString).size(withAttributes: [.font: self.titleFont]).width.rounded(.up) +
								AKTToggleButton.titleInset * 2.0,
				height: AKTToggleButton.height)
	}

	//------------------------------------------------------------------------------------------------------------------
	public override var focusRingMaskBounds :NSRect { self.bounds }

	//------------------------------------------------------------------------------------------------------------------
	public override func drawFocusRingMask() {
		// Draw
		NSBezierPath(roundedRect: self.bounds, xRadius: AKTToggleButton.cornerRadius,
				yRadius: AKTToggleButton.cornerRadius).fill()
	}

	//------------------------------------------------------------------------------------------------------------------
	public override func draw(_ dirtyRect :NSRect) {
		// Setup colors
		let	fillColor :NSColor
		let	borderColor :NSColor
		let	titleColor :NSColor
		switch (self.style, self.state == .on) {
			case (.filled, false):
				// Filled, off
				fillColor = NSColor.labelColor.withAlphaComponent(self.isHighlighted ? 0.14 : 0.06)
				borderColor = NSColor.labelColor.withAlphaComponent(0.25)
				titleColor = NSColor.labelColor.withAlphaComponent(0.7)

			case (.filled, true):
				// Filled, on
				fillColor = self.isHighlighted ? self.onColor.withSystemEffect(.pressed) : self.onColor
				borderColor = fillColor
				titleColor = .white

			case (.outlined, false):
				// Outlined, off
				fillColor = .clear
				borderColor =
						self.isHighlighted ?
								NSColor.secondaryLabelColor.withSystemEffect(.pressed) : NSColor.secondaryLabelColor
				titleColor = borderColor

			case (.outlined, true):
				// Outlined, on
				fillColor = .clear
				borderColor = self.isHighlighted ? self.onColor.withSystemEffect(.pressed) : self.onColor
				titleColor = borderColor
		}

		// Draw button, keeping the border inside the bounds
		let	borderWidth = self.borderWidth
		let	path =
					NSBezierPath(roundedRect: self.bounds.insetBy(dx: borderWidth / 2.0, dy: borderWidth / 2.0),
							xRadius: AKTToggleButton.cornerRadius, yRadius: AKTToggleButton.cornerRadius)
		path.lineWidth = borderWidth

		NSGraphicsContext.current?.cgContext.setAlpha(self.isEnabled ? 1.0 : 0.4)
		fillColor.setFill()
		path.fill()
		borderColor.setStroke()
		path.stroke()

		// Draw title
		let	title =
					NSAttributedString(string: self.title,
							attributes: [.font: self.titleFont, .foregroundColor: titleColor])
		let	titleSize = title.size()
		title.draw(
				at: NSPoint(x: (self.bounds.width - titleSize.width) / 2.0,
						y: (self.bounds.height - titleSize.height) / 2.0))
	}
}
