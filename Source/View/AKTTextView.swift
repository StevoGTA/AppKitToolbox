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

	public	var	didChangeProc :(_ string :String) -> Void = { _ in }

	// MARK: NSTextView methods
	//------------------------------------------------------------------------------------------------------------------
	override public func didChangeText() {
		// Call proc
		self.didChangeProc(self.textStorage!.string)
	}
}
