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

			private	var	contentClipView :AKTFlippedClipView?
			private	var	contentScrollView :NSScrollView?
			private	var	contentView :NSView?
			private	var	contentViewTrailingLayoutConstraint :NSLayoutConstraint?

			private	var	notificationObserver :NSObjectProtocol?

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	deinit {
		// Cleanup
		cleanup()
	}

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc func setContent(views :[NSView]) {
		// Cleanup
		cleanup()

		// Remove all subviews
		self.subviews.forEach() { $0.removeFromSuperview() }

		// Setup for groups
		self.contentScrollView = NSScrollView()
		self.contentScrollView!.borderType = .noBorder
		self.contentScrollView!.autohidesScrollers = true
		self.contentScrollView!.hasVerticalScroller = true
		self.contentScrollView!.drawsBackground = false

		self.addSubview(self.contentScrollView!)
		self.contentScrollView!.match(self)

		self.contentClipView = AKTFlippedClipView()
		self.contentClipView!.drawsBackground = false
		self.contentScrollView!.contentView = self.contentClipView!
		self.contentClipView!.match(self.contentScrollView!)

		self.contentView = NSView()
		self.contentScrollView!.documentView = self.contentView!
		self.contentView!.alignLeading(to: self.contentClipView!)
		self.contentViewTrailingLayoutConstraint = self.contentView!.alignTrailing(equalTo: self.contentClipView!)
		self.contentView!.alignTop(to: self.contentClipView!)

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
		updateLayoutConstraint()

		// Setup Notifications
		self.notificationObserver =
				NotificationCenter.default.addObserver(forName: NSView.frameDidChangeNotification,
						object: self.contentClipView!, using: { [unowned self] _ in self.updateLayoutConstraint() })
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func setContent(string :String) {
		// Cleanup
		cleanup()

		// Remove all subviews
		self.subviews.forEach() { $0.removeFromSuperview() }

		// Display string centered
		let	label = AKTLabel(string: string, alignment: .center)

		self.addSubview(label)
		label.center(in: self)
		label.match(widthOf: self)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(insertView:atIndex:)
	func insert(_ view :NSView, atIndex index :Int) {
		// Setup
		guard let contentViewSubviewsOrderedVertically =
				self.contentView?.subviews.sorted(by: { $0.frame.minY > $1.frame.minY }) else { return }

		// Add view
		self.contentView!.addSubview(view)
		view.alignLeading(to: self.contentView!, constant: self.contentInsets.left)
		view.alignTrailing(equalTo: self.contentView!, constant: -self.contentInsets.right)

		// Check index
		if index == 0 {
			// Top
			if contentViewSubviewsOrderedVertically.count > 0 {
				// Insert above current top view
				NSLayoutConstraint.deactivate(self.contentView!.constraints(between: self.contentView!,
						and: contentViewSubviewsOrderedVertically.first!))

				view.alignTop(to: self.contentView!, constant: self.contentInsets.top)
				contentViewSubviewsOrderedVertically.first!.spaceVertically(from: view, constant: self.groupSpacing)
			} else {
				// First view
				view.alignTop(to: self.contentView!, constant: self.contentInsets.top)
				view.alignBottom(to: self.contentView!, constant: -self.contentInsets.bottom)
			}
		} else if index < contentViewSubviewsOrderedVertically.count {
			// Middle
			let	aboveView = contentViewSubviewsOrderedVertically[index - 1]
			let	belowView = contentViewSubviewsOrderedVertically[index]
			NSLayoutConstraint.deactivate(self.contentView!.constraints(between: aboveView, and: belowView))

			view.spaceVertically(from: aboveView, constant: self.groupSpacing)
			belowView.spaceVertically(from: view, constant: self.groupSpacing)
		} else {
			// Bottom
			let	aboveView = contentViewSubviewsOrderedVertically.last!
			NSLayoutConstraint.deactivate(
					self.contentView!.constraints(between: self.contentView!, and: aboveView)
							.filter({ $0.firstAttribute == .bottom }))

			view.spaceVertically(from: aboveView, constant: self.groupSpacing)
			view.alignBottom(to: self.contentView!, constant: -self.contentInsets.bottom)
		}

		// Finalize
		updateLayoutConstraint()
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(removeView:)
	func remove(_ view :NSView) {
		// Setup
		guard let contentView = self.contentView else { return }
		let	contentViewSubviewsOrderedVertically = contentView.subviews.sorted(by: { $0.frame.minY > $1.frame.minY })
		guard let index = contentViewSubviewsOrderedVertically.firstIndex(of: view) else { return }

		// Remove view
		view.removeFromSuperview()

		// Check position
		if index == 0 {
			// Top view
			contentViewSubviewsOrderedVertically[1].alignTop(to: contentView, constant: self.contentInsets.top)
		} else if index < (contentViewSubviewsOrderedVertically.count - 1) {
			// Middle view
			contentViewSubviewsOrderedVertically[index + 1].spaceVertically(
						from: contentViewSubviewsOrderedVertically[index - 1], constant: self.groupSpacing)
		} else {
			// Bottom view
			contentViewSubviewsOrderedVertically[index - 1].alignBottom(to: contentView,
					constant: -self.contentInsets.bottom)
		}
	}

	// MARK: Private methods
	//------------------------------------------------------------------------------------------------------------------
	private func cleanup() {
		// Cleanup
		self.contentScrollView = nil
		self.contentViewTrailingLayoutConstraint = nil

		if self.notificationObserver != nil { NotificationCenter.default.removeObserver(self.notificationObserver!) }
	}

	//------------------------------------------------------------------------------------------------------------------
	private func updateLayoutConstraint() {
		// Setup
		guard let contentScrollView = self.contentScrollView,
				let contentViewTrailingLayoutConstraint = self.contentViewTrailingLayoutConstraint else { return }

		// Wait a beat
		DispatchQueue.main.async() {
			// Update layout constraint
			NSAnimationContext.current.duration = 0.1
			contentViewTrailingLayoutConstraint.animator().constant =
					!(contentScrollView.verticalScroller?.isHidden ?? true) ?
							-contentScrollView.verticalScroller!.bounds.size.width : 0.0
 		}
	}
}
