//
//  AKTGroupTableView.swift
//  AppKit Toolbox
//
//  Created by Stevo on 3/11/26.
//

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTGroupTableView
public class AKTGroupTableView : AKTTableView, NSTableViewDataSource, NSTableViewDelegate {

	// MARK: Types
	private enum Row {
		case group(groupIndex :Int)
		case item(groupIndex :Int, itemIndex :Int)
	}

	// MARK: Properties
	@objc			var	groupCountProc :() -> Int = { 0 }
	@objc			var	itemCountProc :(_ groupIndex :Int) -> Int = { _ in 0 }
	@objc			var	groupViewProc :(_ groupIndex :Int, _ tableView :NSTableView) -> NSView? = { _,_ in nil }
	@objc			var	itemViewProc
								:(_ groupIndex :Int, _ itemIndex :Int,  _ tableView :NSTableView,
												_ tableColumn :NSTableColumn) -> NSView? =
										{ _,_,_,_ in nil }

			private	var	rows = [Row]()

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	override public init(frame :NSRect) {
		// Do super
		super.init(frame: frame)

		// Setup
		self.dataSource = self
		self.delegate = self
	}

	//------------------------------------------------------------------------------------------------------------------
	required public init?(coder :NSCoder) {
		// Do super
		super.init(coder: coder)

		// Setup
		self.dataSource = self
		self.delegate = self
	}

	// MARK :NSTableView methods
	//------------------------------------------------------------------------------------------------------------------
	public override func reloadData() {
		// Reload rows
		self.rows = []

		// Iteratoe groups
		for groupIndex in 0..<self.groupCountProc() {
			// Add Group
			self.rows.append(.group(groupIndex: groupIndex))

			// Add items
			for itemIndex in 0..<self.itemCountProc(groupIndex) {
				// Add item
				self.rows.append(.item(groupIndex: groupIndex, itemIndex: itemIndex))
			}
		}

		// Do super
		super.reloadData();
	}

	// MARK: NSTableViewDataSource methods
	//------------------------------------------------------------------------------------------------------------------
	public func numberOfRows(in tableView :NSTableView) -> Int { self.rows.count }

	// MARK: NSTableViewDelegate methods
	//------------------------------------------------------------------------------------------------------------------
	public func tableView(_ tableView :NSTableView, isGroupRow row :Int) -> Bool {
		// Check item
		switch self.rows[row] {
			case .group(_):		return true
			case .item(_, _):	return false
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	public func tableView(_ tableView :NSTableView, viewFor tableColumn :NSTableColumn?, row :Int) -> NSView? {
		// Check item
		switch self.rows[row] {
			case .group(let	groupIndex):
				// Group
				return self.groupViewProc(groupIndex, tableView)

			case .item(let groupIndex, let itemIndex):
				// Item
				return self.itemViewProc(groupIndex, itemIndex, tableView, tableColumn!)
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	public func tableView(_ tableView :NSTableView, shouldSelectRow row :Int) -> Bool {
		// Check item
		switch self.rows[row] {
			case .group(_):		return false
			case .item(_, _):	return true
		}
	}
}
