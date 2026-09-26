//----------------------------------------------------------------------------------------------------------------------
//	AKTTableViewBacking.swift		©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTableViewBacking
public class AKTTableViewBacking : TableViewBacking, NSTableViewDataSource, NSTableViewDelegate {

	// MARK: Properties
	@objc		public			var	selectedObjectsCount :Int { self.tableView.selectedRowIndexes.count }
	@objc		public			var	selectedObjects :[Any] { objects(for: self.selectedObjectIDs) }
	@objc		public			var	selectedObjectIDs :[String]
										{ self.tableView.selectedRowIndexes.map({ itemID(at: $0) }) }

	@objc		public			var	tableColumnDidMoveProc
										:(_ tableView :NSTableView, _ tableColumn :NSTableColumn, _ oldIndex :Int,
												_ newIndex :Int) -> Void = { _,_,_,_ in }
	@objc		public			var	tableColumnDidResizeProc
										:(_ tableView :NSTableView, _ tableColumn :NSTableColumn) -> Void = { _,_ in }

	@objc		public			var	objectRowViewProc
										:(_ tableView :NSTableView, _ object :Any) -> NSView? = { _,_ in nil }
	@objc		public			var	objectViewProc
										:(_ tableView :NSTableView, _ tableColumn :NSTableColumn, _ rowIndex :Int,
												_ object :Any) -> NSView? = { _,_,_,_ in nil }
	@objc		public			var	objectHeightProc
										:(_ tableView :NSTableView, _ object :Any) -> NSNumber? = { _,_ in nil }

	@objc		public			var	selectionShouldChangeProc :() -> Bool = { true }
	@objc		public			var	selectionDidChangeProc :() -> Void = {}

	@objc		public			var	sortDescriptorsDidChangeProc
										:(_ tableView :NSTableView, _ sortDescriptors :[NSSortDescriptor]) -> Void =
												{ _,_ in }

	@objc		public			var	shouldEditObjectRowProc
										:(_ tableView :NSTableView, _ object :Any) -> Bool = { _,_ in false }
	@objc		public			var	shouldEditObjectProc
										:(_ tableView :NSTableView, _ tableColumn :NSTableColumn, _ object :Any) ->
												Bool = { _,_,_ in false }

	@objc		public			var	pasteboardWriterForObjectProc
										:(_ object :Any) -> NSPasteboardWriting? = { _ in nil }
	@objc		public			var	validateDropProc
										:(_ tableView :NSTableView, _ info :NSDraggingInfo, _ row :Int,
												_ dropOperation :NSTableView.DropOperation) -> NSDragOperation =
												{ _,_,_,_ in [] }
	@objc		public			var	acceptDropProc
										:(_ info :NSDraggingInfo, _ row :Int,
												_ dropOperation :NSTableView.DropOperation) -> Bool =
												{ _,_,_ in false }

	@IBOutlet			weak	var	tableView :NSTableView!

				private			var	setSortDescriptorsInProgress = false

	// MARK: TableViewBacking methods
	//------------------------------------------------------------------------------------------------------------------
	public override func set(sortDescriptors: [NSSortDescriptor]) {
		// Note
		self.setSortDescriptorsInProgress = true

		// Update NSTableView
		self.tableView.sortDescriptors = sortDescriptors

		// Do super
		super.set(sortDescriptors: sortDescriptors)

		// Done
		self.setSortDescriptorsInProgress = false
	}

	//------------------------------------------------------------------------------------------------------------------
	override func noteContentUpdated() {
		// Reload data
		self.tableView.reloadData()
	}

	// MARK: NSTableViewDataSource methods
	//------------------------------------------------------------------------------------------------------------------
	public func numberOfRows(in tableView :NSTableView) -> Int { self.count }

	//------------------------------------------------------------------------------------------------------------------
	public func tableView(_ tableView :NSTableView, pasteboardWriterForRow row :Int) -> NSPasteboardWriting? {
		// Call proc
		return self.pasteboardWriterForObjectProc(object(at: row))
	}

	//------------------------------------------------------------------------------------------------------------------
	public func tableView(_ tableView :NSTableView, validateDrop info :NSDraggingInfo, proposedRow row :Int,
			proposedDropOperation dropOperation :NSTableView.DropOperation) -> NSDragOperation {
		// Call proc
		return self.validateDropProc(tableView, info, row, dropOperation)
	}

	//------------------------------------------------------------------------------------------------------------------
	public func tableView(_ tableView :NSTableView, acceptDrop info :NSDraggingInfo, row :Int,
			dropOperation :NSTableView.DropOperation) -> Bool {
		// Call proc
		return self.acceptDropProc(info, row, dropOperation)
	}

	// MARK: NSTableViewDelegate methods
	//------------------------------------------------------------------------------------------------------------------
	public func tableViewColumnDidMove(_ notification :Notification) {
		// Setup
		let	oldIndex = notification.userInfo!["NSOldColumn"] as! Int
		let	newIndex = notification.userInfo!["NSNewColumn"] as! Int

		// Call proc
		self.tableColumnDidMoveProc(self.tableView, self.tableView.tableColumns[newIndex], oldIndex, newIndex)
	}

	//------------------------------------------------------------------------------------------------------------------
	public func tableViewColumnDidResize(_ notification :Notification) {
		// Call proc
		self.tableColumnDidResizeProc(self.tableView, notification.userInfo!["NSTableColumn"] as! NSTableColumn)
	}

	//------------------------------------------------------------------------------------------------------------------
	public func tableView(_ tableView :NSTableView, viewFor tableColumn :NSTableColumn?, row :Int) -> NSView? {
		// Return view
		return (tableColumn == nil) ?
				self.objectRowViewProc(tableView, object(at: row)) :
				self.objectViewProc(tableView, tableColumn!, row, object(at: row))
	}

	//------------------------------------------------------------------------------------------------------------------
	public func tableView(_ tableView :NSTableView, heightOfRow row :Int) -> CGFloat {
		// Query height
		if let height = self.objectHeightProc(tableView, object(at: row)) {
			// Have height
			return CGFloat(height.doubleValue)
		} else {
			// Don't have height
			return tableView.rowHeight
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	public func selectionShouldChange(in tableView :NSTableView) -> Bool { self.selectionShouldChangeProc() }

	//------------------------------------------------------------------------------------------------------------------
	public func tableViewSelectionDidChange(_ notification :Notification) { self.selectionDidChangeProc() }

	//------------------------------------------------------------------------------------------------------------------
	public func tableView(_ tableView :NSTableView, sortDescriptorsDidChange oldDescriptors :[NSSortDescriptor]) {
		// Check if we are doing it
		if self.setSortDescriptorsInProgress {
			// Yep
			return
		}

		// Update
		super.set(sortDescriptors: tableView.sortDescriptors)

		// Call proc
		self.sortDescriptorsDidChangeProc(tableView, tableView.sortDescriptors)
	}

	//------------------------------------------------------------------------------------------------------------------
	public func tableView(_ tableView :NSTableView, shouldEdit tableColumn :NSTableColumn?, row :Int) -> Bool {
		// Call proc
		return (tableColumn == nil) ?
				self.shouldEditObjectRowProc(tableView, object(at: row)) :
				self.shouldEditObjectProc(tableView, tableColumn!, object(at: row))
	}

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc func setup() {
		// Setup
		self.tableView?.dataSource = self
		self.tableView?.delegate = self
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(objectAtRow:)
	func object(at row :Int) -> Any { object(for: itemID(at: row)) }

	//------------------------------------------------------------------------------------------------------------------
	@objc(rowIndexesForObjectIDs:)
	func rowIndexes(for objectIDs :[String]) -> IndexSet { IndexSet(objectIDs.compactMap({ index(of: $0) })) }
}
