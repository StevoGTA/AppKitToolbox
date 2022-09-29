//----------------------------------------------------------------------------------------------------------------------
//	AKTCollectionView.swift			©2022 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTCollectionView
class AKTCollectionView : NSCollectionView {

	// MARK: Properties
	var	menuProc :(_ indexPath :IndexPath?) -> NSMenu? = { _ in nil }

	// MARK: NSView methods
	//------------------------------------------------------------------------------------------------------------------
	override func menu(for event :NSEvent) -> NSMenu? {
		// Setup
		let	point = self.convert(event.locationInWindow, from: nil)
		let	indexPath = self.indexPathForItem(at: point)

		// Check indexPath
		if indexPath != nil {
			// Contextual menu on an item
			if !self.selectionIndexPaths.contains(indexPath!) {
				// Item is not in the selection, change the selection
				animator().selectionIndexPaths = Set<IndexPath>([indexPath!])
			}
		} else {
			// Contextual menu not on an item
			if !self.selectionIndexPaths.isEmpty {
				// Clear selection
				animator().selectionIndexPaths = Set<IndexPath>([])
			}
		}

		return self.menuProc(indexPath) ?? super.menu(for: event)
	}
}
