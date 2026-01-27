//----------------------------------------------------------------------------------------------------------------------
//	AKTOutlineViewBacking.swift		©2024 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTOutlineViewBacking
public class AKTOutlineViewBacking : OutlineViewBacking, NSOutlineViewDataSource, NSOutlineViewDelegate {

	// MARK: Properties
	@objc		public			var	selectedObjectsCount :Int { self.outlineView.selectedItems.count }
	@objc		public			var	selectedObjects :[Any]
											{ objects(for: self.outlineView.selectedItems.map({ $0 as! String })) }

	@objc		public			var	tableColumnDidMoveProc
										:(_ outlineView :NSOutlineView, _ tableColumn :NSTableColumn, _ oldIndex :Int,
												_ newIndex :Int) -> Void = { _,_,_,_ in }
	@objc		public			var	tableColumnDidResizeProc
										:(_ outlineView :NSOutlineView, _ tableColumn :NSTableColumn) -> Void =
												{ _,_ in }

	@objc		public			var	itemRowViewProc
											:(_ outlineView :NSOutlineView, _ item :Any) -> NSView? = { _,_ in nil }
	@objc		public			var	itemViewProc
										:(_ outlineView :NSOutlineView, _ tableColumn :NSTableColumn, _ rowIndex :Int,
												_ item :Any) -> NSView? = { _,_,_,_ in nil }
	@objc		public			var	itemDidExpandProc :(_ item :Any) -> Void = { _ in }
	@objc		public			var	itemDidCollapseProc :(_ item :Any) -> Void = { _ in }

	@objc		public			var	selectionShouldChangeProc :() -> Bool = { true }
	@objc		public			var	selectionDidChangeProc :() -> Void = {}

	@objc		public			var	sortDescriptorsDidChangeProc
										:(_ outlineView :NSOutlineView, _ sortDescriptors :[NSSortDescriptor]) -> Void =
												{ _,_ in }

	@objc		public			var	shouldEditItemRowProc
										:(_ outlineView :NSOutlineView, _ item :Any) -> Bool = { _,_ in false }
	@objc		public			var	shouldEditItemProc
										:(_ outlineView :NSOutlineView, _ tableColumn :NSTableColumn, _ item :Any) ->
												Bool = { _,_,_ in false }

	@IBOutlet			weak	var	outlineView :NSOutlineView!

				private			var	outlineTableColumnIndex :Int?

				private			var	setSortDescriptorsInProgress = false

	// MARK: OutlineViewBacking methods
	//------------------------------------------------------------------------------------------------------------------
	public override func set(sortDescriptors: [NSSortDescriptor]) {
		// Note
		self.setSortDescriptorsInProgress = true

		// Update NSOutlineView
		self.outlineView.sortDescriptors = sortDescriptors

		// Do super
		super.set(sortDescriptors: sortDescriptors)

		// Done
		self.setSortDescriptorsInProgress = false
	}

	//------------------------------------------------------------------------------------------------------------------
	override func noteContentUpdated() {
		// Reload data
		self.outlineView.reloadData()
	}

	// MARK: NSOutlineViewDataSource methods
	//------------------------------------------------------------------------------------------------------------------
	public func outlineView(_ outlineView :NSOutlineView, numberOfChildrenOfItem item :Any?) -> Int {
		// Return child count
		return childCount(for: item as? String)
	}

	//------------------------------------------------------------------------------------------------------------------
	public func outlineView(_ outlineView :NSOutlineView, child index :Int, ofItem item :Any?) -> Any {
		// Return child
		return childItemID(for: item as? String, at: index)
	}

	//------------------------------------------------------------------------------------------------------------------
	public func outlineView(_ outlineView :NSOutlineView, isItemExpandable item :Any) -> Bool {
		// Check if have children only if can expand items
		return !(self.outlineView.outlineTableColumn?.isHidden ?? true) ? (childCount(for: item as? String) > 0) : false
	}

	// MARK: NSOutlineViewDelegate methods
	//------------------------------------------------------------------------------------------------------------------
    public func outlineViewColumnDidMove(_ notification :Notification) {
    	// Setup
    	let	oldIndex = notification.userInfo!["NSOldColumn"] as! Int
    	let	newIndex = notification.userInfo!["NSNewColumn"] as! Int

		// Validate
		if (oldIndex == self.outlineTableColumnIndex) || (newIndex == self.outlineTableColumnIndex) {
			// User trying to mess with the outline table column
			self.outlineView.moveColumn(newIndex, toColumn: oldIndex)
		} else {
			// Call proc
			self.tableColumnDidMoveProc(self.outlineView, self.outlineView.tableColumns[newIndex], oldIndex, newIndex)
		}
    }

	//------------------------------------------------------------------------------------------------------------------
    public func outlineViewColumnDidResize(_ notification :Notification) {
    	// Setup
    	let	tableColumn = notification.userInfo!["NSTableColumn"] as! NSTableColumn

    	// Check table column
    	if tableColumn != self.outlineView.outlineTableColumn {
    		// Call proc
    		self.tableColumnDidResizeProc(self.outlineView, tableColumn)
    	}
    }

	//------------------------------------------------------------------------------------------------------------------
	public func outlineViewItemDidExpand(_ notification: Notification) {
		// Call proc
		self.itemDidExpandProc(object(for: notification.userInfo!["NSObject"] as! String))
	}

	//------------------------------------------------------------------------------------------------------------------
	public func outlineViewItemDidCollapse(_ notification: Notification) {
		// Call proc
		self.itemDidCollapseProc(object(for: notification.userInfo!["NSObject"] as! String))
	}

	//------------------------------------------------------------------------------------------------------------------
	public func outlineView(_ outlineView :NSOutlineView, mouseDownInHeaderOf tableColumn :NSTableColumn) {
		// Can reorder all but the outline Table Column
		outlineView.allowsColumnReordering = tableColumn != outlineView.outlineTableColumn
	}

	//------------------------------------------------------------------------------------------------------------------
	public func outlineView(_ outlineView :NSOutlineView, viewFor tableColumn :NSTableColumn?, item :Any) -> NSView? {
		// Return view
		if tableColumn == nil {
			// Row view
			return self.itemRowViewProc(outlineView, object(for: (item as! String)))
		} else if tableColumn != outlineView.outlineTableColumn {
			// Cell view
			return self.itemViewProc(outlineView, tableColumn!, self.outlineView.row(forItem: item),
					object(for: (item as! String)))
		} else {
			// Outline Table Column
			return nil
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	public func selectionShouldChange(in outlineView :NSOutlineView) -> Bool { self.selectionShouldChangeProc() }

	//------------------------------------------------------------------------------------------------------------------
	public func outlineViewSelectionDidChange(_ notification :Notification) { self.selectionDidChangeProc() }

	//------------------------------------------------------------------------------------------------------------------
	public func outlineView(_ outlineView :NSOutlineView, sortDescriptorsDidChange oldDescriptors :[NSSortDescriptor]) {
		// Check if we are doing it
		if self.setSortDescriptorsInProgress {
			// Yep
			return
		}

		// Update
		super.set(sortDescriptors: outlineView.sortDescriptors)

		// Call proc
		self.sortDescriptorsDidChangeProc(outlineView, outlineView.sortDescriptors)
	}

	//------------------------------------------------------------------------------------------------------------------
    public func outlineView(_ outlineView :NSOutlineView, shouldEdit tableColumn :NSTableColumn?, item :Any) -> Bool {
    	// Call proc
    	return (tableColumn == nil) ?
    			self.shouldEditItemRowProc(outlineView, object(for: (item as! String))) :
    			self.shouldEditItemProc(outlineView, tableColumn!, object(for: (item as! String)))
    }

    // MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc func setup() {
		// Setup
		self.outlineView?.dataSource = self
		self.outlineView?.delegate = self
		self.outlineTableColumnIndex =
				(self.outlineView?.outlineTableColumn != nil) ?
						self.outlineView!.tableColumns.firstIndex(of: self.outlineView!.outlineTableColumn!) : nil
	}
	
	//------------------------------------------------------------------------------------------------------------------
	@objc(objectAtRow:)
	func object(at row :Int) -> Any { object(for: self.outlineView.item(atRow: row) as! String) }
}
