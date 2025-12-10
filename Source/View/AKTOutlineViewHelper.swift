//----------------------------------------------------------------------------------------------------------------------
//	AKTOutlineViewHelper.swift		©2024 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTOutlineViewHelper
public class AKTOutlineViewHelper : NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate {

	// MARK: Properties
	@objc		public			var	selectedItemIDs :[String] { self.outlineView.selectedItems.map({ $0 as! String }) }

	// If itemID is nil, then info for the top-level should be returned
	@objc		public			var	hasChildrenProc :(_ itemID :String) -> Bool = { _ in false }
	@objc		public			var	childCountProc :(_ itemID :String?) -> Int = { _ in 0 }
	@objc		public			var	childItemIDProc :(_ itemID :String?, _ index :Int) -> String = { _,_ in "" }

	@objc		public			var	selectionDidChangeProc :() -> Void = {}
	@objc		public			var	sortDescriptorsDidChangeProc
										:(_ outlineView :NSOutlineView, _ sortDescriptors :[NSSortDescriptor]) -> Void =
												{ _,_ in }
	@objc		public			var	viewProc
										:(_ outlineView :NSOutlineView, _ tableColumn :NSTableColumn?,
												_ itemID :String?) -> NSView? = { _,_,_ in nil }

	@IBOutlet			weak	var	outlineView :NSOutlineView!

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
	public func outlineView(_ outlineView :NSOutlineView, numberOfChildrenOfItem item :Any?) -> Int {
		// Return child count
		return self.childCountProc(item as? String)
	}

	//------------------------------------------------------------------------------------------------------------------
	public func outlineView(_ outlineView :NSOutlineView, child index :Int, ofItem item :Any?) -> Any {
		// Return child
		return self.childItemIDProc(item as? String, index)
	}

	//------------------------------------------------------------------------------------------------------------------
	public func outlineView(_ outlineView :NSOutlineView, isItemExpandable item :Any) -> Bool {
		// Return if child count > 0
		return self.hasChildrenProc(item as! String)
	}

	// MARK: NSOutlineViewDelegate methods
	//------------------------------------------------------------------------------------------------------------------
	public func outlineView(_ outlineView :NSOutlineView, viewFor tableColumn :NSTableColumn?, item :Any) -> NSView? {
		// Return view
		return self.viewProc(outlineView, tableColumn, item as? String)
	}

	//------------------------------------------------------------------------------------------------------------------
	public func outlineViewSelectionDidChange(_ notification :Notification) {
		// Call proc
		self.selectionDidChangeProc()
	}

	//------------------------------------------------------------------------------------------------------------------
	public func outlineView(_ outlineView :NSOutlineView, sortDescriptorsDidChange oldDescriptors :[NSSortDescriptor]) {
		// Call proc
		self.sortDescriptorsDidChangeProc(outlineView, outlineView.sortDescriptors)
	}

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	public func reload() { self.outlineView.reloadData() }

	//------------------------------------------------------------------------------------------------------------------
	public func reload(itemID :String, reloadChildren :Bool = false) {
		// Reload
		self.outlineView.reloadItem(itemID, reloadChildren: reloadChildren)
	}
}
