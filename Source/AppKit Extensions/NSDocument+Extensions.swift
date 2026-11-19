//----------------------------------------------------------------------------------------------------------------------
//	NSDocument+Extensions.swift			©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSDocument extensions
extension NSDocument {

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc public func noteShouldNotClose(to delegate :NSObject, shouldCloseSelector :Selector,
			contextInfo :UnsafeMutableRawPointer?) {
		// Call selector
		typealias	Proc = @convention(c) (NSObject, Selector, NSDocument, Bool, UnsafeMutableRawPointer?) -> Void
		unsafeBitCast(delegate.method(for: shouldCloseSelector), to: Proc.self)(delegate, shouldCloseSelector, self,
				false, contextInfo)
	}
}
