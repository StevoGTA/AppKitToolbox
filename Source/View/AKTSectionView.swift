//----------------------------------------------------------------------------------------------------------------------
//	AKTSectionView.swift			©2022 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTSectionView
public class AKTSectionView : NSView {

	// MARK: Properties
	@objc			var	contentInsets = NSEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
	@objc			var	groupSpacing :CGFloat = 8.0

			private	var	contentView :NSView?
			private	var	notifcationObserver :NSObjectProtocol?

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	deinit {
		// Cleanup
		if self.notifcationObserver != nil { NotificationCenter.default.removeObserver(self.notifcationObserver!) }
	}

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc func setContent(views :[NSView]) {
		// Remove all subviews
		self.subviews.forEach() { $0.removeFromSuperview() }

		// Setup for groups
		let scrollView = NSScrollView()
		scrollView.borderType = .noBorder
		scrollView.autohidesScrollers = true
		scrollView.hasVerticalScroller = true
		scrollView.drawsBackground = false

		self.addSubview(scrollView)
		scrollView.match(self)

		let clipView = AKTFlippedClipView()
		clipView.drawsBackground = false
		scrollView.contentView = clipView
		clipView.match(scrollView)

		self.contentView = NSView()
		scrollView.documentView = self.contentView!
		self.contentView!.alignLeading(to: clipView)
		let	layoutConstraint = self.contentView!.alignTrailing(equalTo: clipView)
		self.contentView!.alignTop(to: clipView)

		// Iterate groups
		var	previousView :NSView? = nil
		views.forEach() {
			// Add GroupView
			self.contentView!.addSubview($0)
			$0.alignLeading(to: self.contentView!, constant: self.contentInsets.left)
			$0.alignTrailing(equalTo: self.contentView!, constant: -self.contentInsets.right)
			if previousView != nil {
				// Have previous view
				$0.spaceVertically(from: previousView!, constant: self.groupSpacing)
			} else {
				// Don't have previous view
				$0.alignTop(to: self.contentView!, constant: self.contentInsets.top)
			}

			// Update
			previousView = $0
		}

		// Finalize
		previousView?.alignBottom(to: self.contentView!, constant: -self.contentInsets.bottom)
		updateLayoutConstraint(scrollView: scrollView, layoutConstraint: layoutConstraint)

		// Setup Notifications
		self.notifcationObserver =
				NotificationCenter.default.addObserver(forName: NSView.frameDidChangeNotification, object: clipView,
						using: { [unowned self, scrollView, layoutConstraint] _ in
							// Update layout constraint
							self.updateLayoutConstraint(scrollView: scrollView, layoutConstraint: layoutConstraint)
						})
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func setContent(string :String) {
		// Remove all subviews
		self.subviews.forEach() { $0.removeFromSuperview() }

		// Display string centered
		let	label = AKTLabel(string: string, alignment: .center)

		self.addSubview(label)
		label.center(in: self)
		label.match(widthOf: self)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc (removeView:)
	func remove(_ view :NSView) {
		// Setup
		guard let contentView = self.contentView else { return }
		guard let index = contentView.subviews.firstIndex(of: view) else { return }

		// Remove view
		view.removeFromSuperview()

		// Check position
		if index == 0 {
			// Top view
			contentView.subviews[0].alignTop(to: contentView, constant: self.contentInsets.top)
		} else if index == (self.subviews.count - 1) {
			// Middle view
			contentView.subviews[index].spaceVertically(from: contentView.subviews[index - 1])
		} else {
			// Bottom view
			contentView.subviews[index - 1].alignBottom(to: contentView, constant: -self.contentInsets.bottom)
		}
	}

	// MARK: Private methods
	//------------------------------------------------------------------------------------------------------------------
	private func updateLayoutConstraint(scrollView :NSScrollView, layoutConstraint :NSLayoutConstraint) {
		// Wait a beat
		DispatchQueue.main.async() { [unowned scrollView, unowned layoutConstraint] in
			// Update layout constraint
			NSAnimationContext.current.duration = 0.1
			layoutConstraint.animator().constant =
					!(scrollView.verticalScroller?.isHidden ?? true) ?
							-scrollView.verticalScroller!.bounds.size.width : 0.0
 		}
	}
}
