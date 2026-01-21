//----------------------------------------------------------------------------------------------------------------------
//	AKTScrollView.swift		©2025 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTScrollView
public class AKTScrollView : NSScrollView {

	// MARK: Properties
	public	var	viewBoundsDidChangeProc :() -> Void = {}

	private	var	viewBoundsDidChangeNotificationCenterObserver :NotificationCenter.Observer!

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	override init(frame :NSRect) {
		// Do super
		super.init(frame: frame)

		// Setup notifications
		self.viewBoundsDidChangeNotificationCenterObserver =
				NotificationCenter.Observer(name: NSView.boundsDidChangeNotification, object: self.contentView,
						proc: { _ in MainActor.assumeIsolated() { [unowned self] in self.viewBoundsDidChangeProc() } })
	}

	//------------------------------------------------------------------------------------------------------------------
	required init?(coder :NSCoder) {
		// Do super
		super.init(coder: coder)

		// Setup notifications
		self.viewBoundsDidChangeNotificationCenterObserver =
				NotificationCenter.Observer(name: NSView.boundsDidChangeNotification, object: self.contentView,
						proc: { _ in MainActor.assumeIsolated() { [unowned self] in self.viewBoundsDidChangeProc() } })
	}
}
