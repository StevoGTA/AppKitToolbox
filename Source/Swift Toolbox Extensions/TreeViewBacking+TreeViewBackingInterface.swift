//----------------------------------------------------------------------------------------------------------------------
//	TreeViewBacking+TreeViewBackingInterface.swift		©2024 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------
// MARK: TreeViewBacking extension
extension TreeViewBacking : AKTTreeViewBackingInterface {

	// MRK: Properties
	public	var	rootItemID :String { type(of: self).rootItemID }

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	public func hasChildren(ofItemID itemID :String) -> Bool { hasChildren(of: itemID) }

	//------------------------------------------------------------------------------------------------------------------
	public func childCount(ofItemID itemID :String) -> Int { childCount(of: itemID) }

	//------------------------------------------------------------------------------------------------------------------
	public func childItemID(ofItemID itemID :String, at index :Int) -> String { childItemID(of: itemID, index: index) }
}
