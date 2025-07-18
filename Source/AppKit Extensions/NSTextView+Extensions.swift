//----------------------------------------------------------------------------------------------------------------------
//	NSTextView+Extensions.swift			©2025 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit
import Foundation

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSTextView extension
public extension NSTextView {

	// MARK: Renderer
	struct Renderer {

		// MARK: Properties
		static	public	let	standardDateTextFormat = "{DATE}{TEXT}\n"
		static	public	let	standardTextFormat = "{TEXT}\n"

				private	let	format :String
				private	let	dateFormatter :DateFormatter?
				private	let	textColor :NSColor
				private	let	font :NSFont

		// MARK: Lifecycle methods
		//--------------------------------------------------------------------------------------------------------------
		public init(format :String = standardDateTextFormat, textColor :NSColor = .controlTextColor,
				font :NSFont = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular), dateFormat :String? = nil) {
			// Store
			self.format = format
			self.textColor = textColor
			self.font = font

			// Setup
			self.dateFormatter = (dateFormat != nil) ? DateFormatter(dateFormat: dateFormat!) : nil
		}

		// MARK: Instance methods
		//--------------------------------------------------------------------------------------------------------------
		fileprivate func transform(text :String) -> NSAttributedString {
			// Setup
			let	attributedString = NSMutableAttributedString(string: self.format)
			if let range = attributedString.string.range(of: "{DATE}") {
				// Replace
				attributedString.replaceCharacters(in: NSRange(range, in: attributedString.string),
						with:
								NSAttributedString(string: self.dateFormatter?.string(from: Date()) ?? "",
										attributes:
												[
													.foregroundColor : NSColor.controlTextColor,
													.font: self.font
												]))
			}
			if let range = attributedString.string.range(of: "{TEXT}") {
				// Replace
				attributedString.replaceCharacters(in: NSRange(range, in: attributedString.string),
						with:
								NSAttributedString(string: text,
										attributes:
												[
													.foregroundColor : self.textColor,
													.font: self.font,
												]))
			}

			return attributedString
		}
	}

	// MARK: Properties
	@objc	var	isEmpty :Bool { self.textStorage?.string.isEmpty ?? true }

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	func append(attributedText :NSAttributedString) {
		// Get info
		var	originalHasVerticalScroller = false
		var	originalScrollValue = 0.0

		let	scrollView = self.superview?.superview as? NSScrollView
		if let scrollView {
			// Contained within an NSScrollView
			originalHasVerticalScroller = scrollView.hasVerticalScroller
			originalScrollValue = scrollView.verticalScroller!.doubleValue
		}

		// Append text
		self.textStorage?.append(attributedText)

		// Update scroll position
		if (!originalHasVerticalScroller && (scrollView?.hasVerticalScroller ?? false)) ||
				(originalScrollValue == 1.0) {
			// Scroll to visible
			scrollRangeToVisible(NSRange(location: self.textStorage!.length, length: 0))
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	func append(text :String, renderer :Renderer) { append(attributedText: renderer.transform(text: text)) }
}
