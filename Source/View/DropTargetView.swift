//----------------------------------------------------------------------------------------------------------------------
//	DropTargetView.swift		©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: DropTargetView
class DropTargetView : NSView {

	// MARK: Types
	typealias QueryAcceptItemsProc = (_ pasteboardType :NSPasteboard.PasteboardType, _ items :[Any]) -> Bool
	typealias ReceiveItemsProc = (_ pasteboardType :NSPasteboard.PasteboardType, _ items :[Any]) -> Void

	// MARK: Properties
	@objc	var	queryAcceptItemsProc :QueryAcceptItemsProc = { _, _ in return false }
	@objc	var	receiveItemsProc :ReceiveItemsProc = { _,_ in }

	// MARK: NSDraggingDestination methods
	//------------------------------------------------------------------------------------------------------------------
	override func draggingEntered(_ draggingInfo :NSDraggingInfo) -> NSDragOperation {
		// Iterate all registered pasteboard types
		for pasteboardType in self.registeredDraggedTypes {
			// Get items for this pasteboard type
			guard let item = draggingInfo.draggingPasteboard.propertyList(forType: pasteboardType) else { continue }

			// Call proc
			if self.queryAcceptItemsProc(pasteboardType, [item]) {
				// Success!
				return [.copy]
			}
		}

		return []
	}

	//------------------------------------------------------------------------------------------------------------------
	override func performDragOperation(_ draggingInfo :NSDraggingInfo) -> Bool {
		// Iterate all registered pasteboard types
		for pasteboardType in self.registeredDraggedTypes {
			// Get items for this pasteboard type
			guard let items = draggingInfo.draggingPasteboard.propertyList(forType: pasteboardType) as? [Any] else
					{ continue }

			// Call proc
			if self.queryAcceptItemsProc(pasteboardType, items) {
				// Do it
				self.receiveItemsProc(pasteboardType, items)

				// Success
				return true
			}
		}

		return false
	}
}
