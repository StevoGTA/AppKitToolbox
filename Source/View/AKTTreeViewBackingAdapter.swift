//----------------------------------------------------------------------------------------------------------------------
//	AKTTreeViewBackingAdapter.swift		©2024 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTreeViewBackingAdapter
public class AKTTreeViewBackingAdapter : NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate {

	// MARK: Properties
	@objc		public			var	selectionDidChangeProc :() -> Void = {}
	@objc		public			var	viewProc
										:(_ outlineView :NSOutlineView, _ tableColumn :NSTableColumn?, _ itemID :String)
												-> NSView? = { _,_,_ in nil }

	@IBOutlet			weak	var	outlineView :NSOutlineView!
	@IBOutlet			weak	var	treeViewBackingInterface :AKTTreeViewBackingInterface!

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	public override func awakeFromNib() {
		// Do super
		super.awakeFromNib()

		// Setup
		self.outlineView?.dataSource = self
		self.outlineView?.delegate = self
	}

	// MARK: NSOutlineViewDataSource methods
	//------------------------------------------------------------------------------------------------------------------
	public func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
		// Return child count
		return self.treeViewBackingInterface.childCount(ofItemID: self.itemID(for: item))
	}

	//------------------------------------------------------------------------------------------------------------------
	public func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
		// Return child
		return self.treeViewBackingInterface.childItemID(ofItemID: self.itemID(for: item), at: index)
	}

	//------------------------------------------------------------------------------------------------------------------
	public func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
		// Return if child count > 0
		return self.treeViewBackingInterface.hasChildren(ofItemID: self.itemID(for: item))
	}

	// MARK: NSOutlineViewDelegate methods
	//----------------------------------------------------------------------------------------------------------------------
	public func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
		// Return view
		return self.viewProc(outlineView, tableColumn, self.itemID(for: item))
	}

	//----------------------------------------------------------------------------------------------------------------------
	public func outlineViewSelectionDidChange(_ notification: Notification) {
		// Call proc
		self.selectionDidChangeProc();
	}

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	public func reload() { self.outlineView.reloadData() }

	//------------------------------------------------------------------------------------------------------------------
	public func reload(itemID :String, reloadChildren :Bool = false) {
		// Reload
		self.outlineView.reloadItem(itemID, reloadChildren: reloadChildren)
	}

	//------------------------------------------------------------------------------------------------------------------
	public func reload(itemIDs :[String], tableColumnIdentifiers :[NSUserInterfaceItemIdentifier]) {
		// Reload
//		self.outlineView.reloadData(forRowIndexes: <#T##IndexSet#>, columnIndexes: <#T##IndexSet#>)
	}

	// MARK: Private methods
	//------------------------------------------------------------------------------------------------------------------
	private func itemID(for item :Any?) -> String {
		// Convert item to its corresponding id
		return (item != nil) ? item as! String : treeViewBackingInterface.rootItemID
	}
}
