//----------------------------------------------------------------------------------------------------------------------
//	AKTBlockingView.swift		©2024 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTBlockingView
public class AKTBlockingView : NSView {

	// MARK: Properties
	override	public	var	allowedTouchTypes :NSTouch.TouchTypeMask {
									get { [] }
									set {}
								}

	// MARK: NSView methods
	//------------------------------------------------------------------------------------------------------------------
	public override func acceptsFirstMouse(for event :NSEvent?) -> Bool { false }

	//------------------------------------------------------------------------------------------------------------------
	public override func mouseDown(with event :NSEvent) {}

	//------------------------------------------------------------------------------------------------------------------
	public override func rightMouseDown(with event :NSEvent) {}

	//------------------------------------------------------------------------------------------------------------------
	public override func otherMouseDown(with event :NSEvent) {}

	//------------------------------------------------------------------------------------------------------------------
	public override func keyDown(with event :NSEvent) {}
}
