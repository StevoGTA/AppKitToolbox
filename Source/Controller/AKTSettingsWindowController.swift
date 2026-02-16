//----------------------------------------------------------------------------------------------------------------------
//	AKTSettingsWindowController.swift		©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTSettingsWindowController
class AKTSettingsWindowController : NSWindowController {

	// MARK :SettingsPane
	struct SettingsPane {

		// MARK: Properties
		let	identifier :String
		let	title :String
		let	image :NSImage
		let	viewController :NSViewController
	}

	// MARK: Properties
	private	var	settingsPanes :[SettingsPane] = []
	private	var	splitViewController :NSSplitViewController!
	private	var	sidebarViewController :SidebarViewController!
	private	var	currentPaneIdentifier :String?

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	@objc convenience init() {
		// Init with default title
		self.init(title: "Settings", placeholderMessage: "Select a settings pane from the sidebar")
	}

	//------------------------------------------------------------------------------------------------------------------
	convenience init(title :String, placeholderMessage :String) {
		// Setup window
		let	window =
					NSWindow(contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
							styleMask: [.titled, .closable, .miniaturizable, .resizable], backing: .buffered,
							defer: false)
		window.title = title
		window.titlebarAppearsTransparent = true
		window.center()
		window.setFrameAutosaveName("SettingsWindow")
		window.minSize = NSSize(width: 600, height: 400)

		// Do regular init
		self.init(window: window)

		// Setup SplitViewController
		self.splitViewController = NSSplitViewController()
		self.splitViewController.splitView.dividerStyle = .thin
		self.splitViewController.splitView.isVertical = true

		// Create SidebarViewController
		self.sidebarViewController = SidebarViewController()
		self.sidebarViewController.onSettingsPaneSelected = { [unowned self] in self.selectPane(identifier: $0) }
		self.sidebarViewController.numberOfSettingsPanes = { [unowned self] in self.settingsPanes.count }
		self.sidebarViewController.settingsPaneAtIndex = { [unowned self] index in
			// Get pane
			let pane = self.settingsPanes[index]

			return (title: pane.title, image: pane.image, identifier: pane.identifier)
		}
		self.sidebarViewController.indexForIdentifier = { [unowned self] identifier in
			// Find
			self.settingsPanes.firstIndex(where: { $0.identifier == identifier })
		}

		// Add sidebar item
		let	sidebarSplitViewItem = NSSplitViewItem(sidebarWithViewController: self.sidebarViewController)
		sidebarSplitViewItem.minimumThickness = 200
		sidebarSplitViewItem.maximumThickness = 300
		sidebarSplitViewItem.canCollapse = false
		self.splitViewController.addSplitViewItem(sidebarSplitViewItem)

		// Create content area with placeholder
		let	contentSplitViewItem =
					NSSplitViewItem(
							viewController: SettingsPlaceholderViewController(placeholderMessage: placeholderMessage))
		contentSplitViewItem.minimumThickness = 400
		self.splitViewController.addSplitViewItem(contentSplitViewItem)

		// Set content view controller
		self.window?.contentViewController = self.splitViewController
	}

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@discardableResult @objc
	func registerPane(title :String, image :NSImage, viewController :NSViewController) -> String {
		// Setup
		let	identifier = UUID().uuidString

		// Add SettingsPage
		self.settingsPanes.append(
				SettingsPane(identifier: identifier, title: title, image: image, viewController: viewController))

		// Update UI
		self.sidebarViewController.reloadData()

		if self.settingsPanes.count == 1 {
			// Select the first pane automatically
			self.selectPane(identifier: identifier)
		}

		return identifier
	}

	//------------------------------------------------------------------------------------------------------------------
	func selectPane(identifier: String) {
		// Check if the current one
		guard self.currentPaneIdentifier != identifier else { return }

		// Setup
		let	settingsPane = self.settingsPanes.first(where: { $0.identifier == identifier })!

		// Update
		self.currentPaneIdentifier = identifier

		// Update UI
		self.window?.title = settingsPane.title

		let	splitViewItem = self.splitViewController.splitViewItems[1]
		splitViewItem.viewController.removeFromParent()
		splitViewItem.viewController = settingsPane.viewController
		self.splitViewController.addChild(settingsPane.viewController)

		self.sidebarViewController.select(identifier: identifier)
	}
}

//----------------------------------------------------------------------------------------------------------------------
// MARK: - Sidebar View Controller
fileprivate class SidebarViewController : NSViewController, NSTableViewDataSource, NSTableViewDelegate {

	// MARK: Properties
			var	onSettingsPaneSelected: ((_ identifier :String) -> Void)?
			var	numberOfSettingsPanes: (() -> Int)?
			var	settingsPaneAtIndex: ((_ index :Int) -> (title :String, image :NSImage, identifier :String))?
			var	indexForIdentifier: ((_ identifier :String) -> Int?)?

	private	var	tableView: NSTableView!

	// MARK: NSViewController methods
	//------------------------------------------------------------------------------------------------------------------
	override func loadView() {
		// Make view
		self.view = NSView(frame: NSRect(x: 0, y: 0, width: 200, height: 400))

		// Setup ScrollView
		let	scrollView = NSScrollView(frame: self.view.bounds)
		scrollView.autoresizingMask = [.width, .height]
		scrollView.hasVerticalScroller = true
		scrollView.hasHorizontalScroller = false
		scrollView.borderType = .noBorder
		scrollView.drawsBackground = false

		// Setup TableVIew
		self.tableView = NSTableView(frame: scrollView.bounds)
		self.tableView.style = .sourceList
		self.tableView.selectionHighlightStyle = .sourceList
		self.tableView.backgroundColor = .clear
		self.tableView.rowSizeStyle = .default
		self.tableView.intercellSpacing = NSSize(width: 0, height: 0)
		self.tableView.headerView = nil
		self.tableView.focusRingType = .none
		self.tableView.allowsEmptySelection = false
		self.tableView.allowsMultipleSelection = false
		self.tableView.dataSource = self
		self.tableView.delegate = self

		let tableColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("title"))
		tableColumn.width = 200
		self.tableView.addTableColumn(tableColumn)

		// Finalize ScrollView
		scrollView.documentView = self.tableView
		self.view.addSubview(scrollView)
	}

	// MARK: NSTableViewDataSource methods
	//------------------------------------------------------------------------------------------------------------------
	func numberOfRows(in tableView :NSTableView) -> Int { self.numberOfSettingsPanes?() ?? 0 }

	//------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView :NSTableView, viewFor tableColumn :NSTableColumn?, row :Int) -> NSView? {
		// Setup
		let	settingsPane = self.settingsPaneAtIndex!(row)

		// Compose TableCellView
		let	identifier = NSUserInterfaceItemIdentifier("settingsCell")
		var tableCellView = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView
		if tableCellView == nil {
			// Make new
			tableCellView = NSTableCellView(frame: NSRect(x: 0, y: 0, width: 200, height: 32))
			tableCellView!.identifier = identifier

			// Setup Image view
			let	imageView = NSImageView(frame: NSRect(x: 8, y: 4, width: 24, height: 24))
			imageView.imageScaling = .scaleProportionallyDown
			imageView.autoresizingMask = []
			tableCellView!.imageView = imageView
			tableCellView!.addSubview(imageView)

			// Setup Text field
			let	textField = NSTextField(frame: NSRect(x: 40, y: 6, width: 140, height: 20))
			textField.isEditable = false
			textField.isBordered = false
			textField.backgroundColor = .clear
			textField.font = .systemFont(ofSize: 13)
			textField.lineBreakMode = .byTruncatingTail
			textField.autoresizingMask = [.width]
			tableCellView!.textField = textField
			tableCellView!.addSubview(textField)
		}

		// Update UI
		tableCellView!.imageView!.image = settingsPane.image
		tableCellView!.textField!.stringValue = settingsPane.title

		return tableCellView
	}

	// MARK: NSTableViewDelegate methods
	//------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat { 32.0 }

	//------------------------------------------------------------------------------------------------------------------
	func tableViewSelectionDidChange(_ notification: Notification) {
		// Setup
		let selectedRow = self.tableView.selectedRow
		guard selectedRow >= 0 else { return }

		// Call proc
		self.onSettingsPaneSelected?(self.settingsPaneAtIndex!(selectedRow).identifier)
	}

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	func select(identifier: String) {
		// Update TableView
		self.tableView.selectRowIndexes(IndexSet(integer: self.indexForIdentifier!(identifier)!),
				byExtendingSelection: false)
	}

	//------------------------------------------------------------------------------------------------------------------
	func reloadData() {
		// Reload data
		self.tableView.reloadData()
	}
}

//----------------------------------------------------------------------------------------------------------------------
// MARK: - SettingsPlaceholderViewController
fileprivate class SettingsPlaceholderViewController : NSViewController {

	// MARK: Properties
	private	let	placeholderMessage :String

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	init(placeholderMessage :String) {
		// Store
		self.placeholderMessage = placeholderMessage

		// Do super
		super.init(nibName: nil, bundle: nil)
	}
	
	//------------------------------------------------------------------------------------------------------------------
	required init?(coder :NSCoder) { fatalError("init(coder:) has not been implemented") }

	// MARK: NSViewController methods
	//------------------------------------------------------------------------------------------------------------------
	override func loadView() {
		// Setup
		self.view = NSView(frame: NSRect(x: 0, y: 0, width: 400, height: 400))

		// Add Text field
		let	textField = NSTextField(labelWithString: self.placeholderMessage)
		textField.font = .systemFont(ofSize: 14)
		textField.textColor = .secondaryLabelColor
		textField.alignment = .center
		textField.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(textField)
		NSLayoutConstraint.activate([
			textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			textField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
		])
	}
}
