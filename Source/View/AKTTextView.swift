//----------------------------------------------------------------------------------------------------------------------
//	AKTTextView.swift		©2022 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTextView
public class AKTTextView : NSTextView, NSTextStorageDelegate {

	// MARK: Properties
			public	var	stringValue :String {
								get { self.textStorage!.string }
								set {
									// Set string
									self.textStorage!.mutableString.setString(newValue)

									// Apply attributes
									self.textStorage!.addAttribute(.foregroundColor, value: NSColor.controlTextColor,
											range: NSRange(location: 0, length: newValue.count))
									self.textStorage!.addAttribute(.font, value: NSFont.controlContentFont(ofSize: 13.0),
											range: NSRange(location: 0, length: newValue.count))
								}
							}

	@objc	public	var	isValueValid = true { didSet { self.needsDisplay = true } }

	@objc	public	var	didChangeProc :(_ string :String) -> Void = { _ in }

	// MARK: NSView methods
	//------------------------------------------------------------------------------------------------------------------
	override public func draw(_ dirtyRect :NSRect) {
		// Do super
		super.draw(dirtyRect)

		// Check if value is valid
		if !self.isValueValid {
			// Draw border indicating invalid state
			let	bezierPath =
						NSBezierPath(
								roundedRect:
										NSRect(x: 0.0, y: 1.0, width: self.bounds.width,
												height: self.bounds.height - 1.0),
								xRadius: 2.0, yRadius: 2.0)
			bezierPath.lineWidth = 4.0

			NSGraphicsContext.saveGraphicsState()

			NSColor.systemRed.setStroke()
			bezierPath.stroke()

			NSGraphicsContext.restoreGraphicsState()
		}
	}

	// MARK: NSTextView methods
	//------------------------------------------------------------------------------------------------------------------
	override public func didChangeText() {
		// Call proc
		self.didChangeProc(self.textStorage!.string)
	}
}
