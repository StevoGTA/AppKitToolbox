//----------------------------------------------------------------------------------------------------------------------
//	URLControl.swift		©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: URLControl
class URLControl : NSControl {

	// MARK: Properties
			var	urlProc :(_ url :URL) -> Void = { NSWorkspace.shared.open($0) }

	private	var	textAttributedString = NSAttributedString()
	private	var	rect = CGRect.zero
	private	var	url :URL?

	// MARK: NSResponder methods
	//------------------------------------------------------------------------------------------------------------------
	override func mouseDown(with event :NSEvent) {
		// Setup
		let	point = self.convert(event.locationInWindow, from: nil)
		if self.rect.contains(point) {
			// Call proc
			self.urlProc(self.url!)
		}
	}

	// MARK: NSView methods
	//------------------------------------------------------------------------------------------------------------------
	override func draw(_ dirtyRect :NSRect) {
		// Draw
		self.textAttributedString.draw(at: self.rect.origin)
	}

	//------------------------------------------------------------------------------------------------------------------
	override func resetCursorRects() {
		// Setup
		addCursorRect(self.rect, cursor: .pointingHand)
	}

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc func setup(string :String, url :URL) {
		// Update
		self.textAttributedString =
				NSAttributedString(string: string,
						attributes: [
										.foregroundColor: NSColor.blue,
										.underlineStyle: true,
									])
		self.url = url

		// Finish setup
		finishSetup()
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func setup(string :String, url :URL, font :NSFont) {
		// Update
		self.textAttributedString =
				NSAttributedString(string: string,
						attributes: [
										.foregroundColor: NSColor.blue,
										.underlineStyle: true,
										.font: font,
									])
		self.url = url

		// Finish setup
		finishSetup()
	}

	// MARK: Private methods
	//------------------------------------------------------------------------------------------------------------------
	private func finishSetup() {
		// Update rect
		self.rect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: self.textAttributedString.size())

		// Refresh
		self.window?.invalidateCursorRects(for: self)
		self.needsDisplay = true
	}
}
