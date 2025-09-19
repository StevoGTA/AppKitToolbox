//----------------------------------------------------------------------------------------------------------------------
//	AKTScrollView.swift		©2025 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTScrollView
public class AKTScrollView : NSScrollView {

	// MARK: Properties
	public	var	viewBoundsDidChangeProc :() -> Void = {}

	private	var	viewBoundsDidChangeNotificationObserver :NSObjectProtocol!

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	override init(frame :NSRect) {
		// Do super
		super.init(frame: frame)

		// Setup notifications
		self.viewBoundsDidChangeNotificationObserver =
				NotificationCenter.default.addObserver(forName: NSView.boundsDidChangeNotification,
						object: self.contentView, using: { [unowned self] _ in self.viewBoundsDidChangeProc() })
	}

	//------------------------------------------------------------------------------------------------------------------
	required init?(coder :NSCoder) {
		// Do super
		super.init(coder: coder)

		// Setup notifications
		self.viewBoundsDidChangeNotificationObserver =
				NotificationCenter.default.addObserver(forName: NSView.boundsDidChangeNotification,
						object: self.contentView, using: { [unowned self] _ in self.viewBoundsDidChangeProc() })
	}

	//------------------------------------------------------------------------------------------------------------------
	deinit {
		// Cleanup
		NotificationCenter.default.removeObserver(self.viewBoundsDidChangeNotificationObserver!)
	}
}
