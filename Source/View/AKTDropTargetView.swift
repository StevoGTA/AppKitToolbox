//----------------------------------------------------------------------------------------------------------------------
//	AKTDropTargetView.swift		©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTDropTargetView
public class AKTDropTargetView : NSView {

	// MARK: State
	private enum State {
		case idle
		case willAcceptDrop
		case willNotAcceptDrop
	}

	// MARK: Types
	public typealias QueryAcceptItemsProc = (_ pasteboardType :NSPasteboard.PasteboardType, _ items :[Any]) -> Bool
	public typealias ReceiveItemsProc = (_ pasteboardType :NSPasteboard.PasteboardType, _ items :[Any]) -> Void

	// MARK: Properties
			public	var	borderWidth :CGFloat {
								get { self.layer!.borderWidth }
								set { self.layer!.borderWidth = newValue }
							}
			public	var	cornerRadius :CGFloat {
								get { self.layer!.cornerRadius }
								set { self.layer!.cornerRadius = newValue }
							}

			public	var	idleColor = NSColor.clear { didSet { self.updateUI() } }
			public	var	willAcceptColor = NSColor.clear { didSet { self.updateUI() } }
			public	var	willNotAcceptColor = NSColor.clear { didSet { self.updateUI() } }

	@objc	public	var	queryAcceptItemsProc :QueryAcceptItemsProc = { _, _ in false }
	@objc	public	var	receiveItemsProc :ReceiveItemsProc = { _,_ in }

			private	var	state = State.idle

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	override init(frame :NSRect) {
		// Do super
		super.init(frame: frame)

		// Setup
		self.wantsLayer = true
		self.layer!.masksToBounds = true
		self.layer!.borderWidth = 3.0
		self.layer!.cornerRadius = 10.0

		// Update UI
		updateUI()
	}

	//------------------------------------------------------------------------------------------------------------------
	required init?(coder :NSCoder) {
		// Do super
		super.init(coder: coder)

		// Setup
		self.wantsLayer = true
		self.layer!.masksToBounds = true
		self.layer!.borderWidth = 3.0
		self.layer!.cornerRadius = 10.0

		// Update UI
		updateUI()
	}

	// MARK: NSDraggingDestination methods
	//------------------------------------------------------------------------------------------------------------------
	override public func draggingEntered(_ draggingInfo :NSDraggingInfo) -> NSDragOperation {
		// Iterate all registered pasteboard types
		var	dragOperation :NSDragOperation = []
		for pasteboardType in self.registeredDraggedTypes {
			// Get items for this pasteboard type
			guard let item = draggingInfo.draggingPasteboard.propertyList(forType: pasteboardType) else { continue }

			// Call proc
			if self.queryAcceptItemsProc(pasteboardType, [item]) {
				// Success!
				dragOperation = [.copy]
				break
			}
		}

		// Update internals
		self.state = !dragOperation.isEmpty ? .willAcceptDrop : .willNotAcceptDrop

		// Update UI
		updateUI()

		return dragOperation
	}

	//------------------------------------------------------------------------------------------------------------------
	override public func draggingExited(_ sender :NSDraggingInfo?) {
		// Update internals
		self.state = .idle

		// Update UI
		updateUI()
	}

	//------------------------------------------------------------------------------------------------------------------
	override public func performDragOperation(_ draggingInfo :NSDraggingInfo) -> Bool {
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

	//------------------------------------------------------------------------------------------------------------------
	override public func draggingEnded(_ sender :NSDraggingInfo) {
		// Update internals
		self.state = .idle

		// Update UI
		updateUI()
	}

	// MARK: Private methods
	//------------------------------------------------------------------------------------------------------------------
	private func updateUI() {
		// Check state
		switch self.state {
			case .idle:					self.layer!.borderColor = self.idleColor.cgColor
			case .willAcceptDrop:		self.layer!.borderColor = self.willAcceptColor.cgColor
			case .willNotAcceptDrop:	self.layer!.borderColor = self.willNotAcceptColor.cgColor
		}
	}
}

//----------------------------------------------------------------------------------------------------------------------
// MARK: - AKTFolderFileDropTargetView
public class AKTFolderFileDropTargetView : AKTDropTargetView {

	// MARK: Properties
	public	var	queryAcceptFoldersFilesProc :(_ folders :[Folder], _ files :[File]) -> Bool = { _,_ in false }
	public	var	receiveFoldersFilesProc :(_ folders :[Folder], _ files :[File]) -> Void = { _,_ in }

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	override public func awakeFromNib() {
		// Do super
		super.awakeFromNib()

		// Setup
		self.queryAcceptItemsProc = { [unowned self] in
			// Collect Folders and Files
			let	(folders, files) = self.foldersFiles(for: $0, items: $1)

			return self.queryAcceptFoldersFilesProc(folders, files)
		}
		registerForDraggedTypes([.fileURL])
	}

	// MARK: NSDraggingDestination methods
	//------------------------------------------------------------------------------------------------------------------
	override public func performDragOperation(_ draggingInfo :NSDraggingInfo) -> Bool {
		// Retrieve URLs
		let	urls =
					draggingInfo.draggingPasteboard.readObjects(forClasses: [NSURL.self],
							options: [.urlReadingFileURLsOnly : true]) as! [URL]

		// Transmogrify
		let	(folders, files) = foldersFiles(for: urls)

		// Call proc
		self.receiveFoldersFilesProc(folders, files)

		return true
	}

	// MARK: Private methods
	//------------------------------------------------------------------------------------------------------------------
	private func foldersFiles(for pasteboardType :NSPasteboard.PasteboardType, items :[Any]) ->
			(folders :[Folder], files :[File]) {
		// Get urls
		let	urls = items.map({ URL(fileURLWithPath: $0 as! String) })

		return foldersFiles(for: urls)
	}

	//------------------------------------------------------------------------------------------------------------------
	private func foldersFiles(for urls :[URL]) -> (folders :[Folder], files :[File]) {
		// Transmogrify to Folders and Files
		var	folders = [Folder]()
		var	files = [File]()
		urls.forEach() {
			// Check if directory
			if URL(fileURLWithPath: $0.standardized.path).isDirectory {
				// Folder
				folders.append(Folder($0))
			} else {
				// File
				files.append(File($0))
			}
		}

		return (folders, files)
	}
}
