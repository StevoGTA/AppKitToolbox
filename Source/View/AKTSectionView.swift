//----------------------------------------------------------------------------------------------------------------------
//	AKTSectionView.swift			©2022 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTSectionView
public class AKTSectionView : NSView {

	// MARK: Group
	//------------------------------------------------------------------------------------------------------------------
	@objc (AKTSectionViewGroupView)
	class GroupView : NSView {

		// MARK: Properties
		private	let	itemLeadingInset :CGFloat
		private	let	itemTrailingInset :CGFloat

		private	var	titleLabel :AKTLabel!

		private	var	bottomView :NSView!
		private	var	bottomViewAsBottomLayoutConstraint :NSLayoutConstraint!

		// MARK: Lifecycle methods
		//--------------------------------------------------------------------------------------------------------------
		@objc init(title :String, collapsible :Bool = false, itemLeadingInset :CGFloat = 20.0,
				itemTrailingInset :CGFloat = 0.0) {
			// Store
			self.itemLeadingInset = itemLeadingInset
			self.itemTrailingInset = itemTrailingInset

			// Do super
			super.init(frame: .zero)

			// Setup for content
			self.translatesAutoresizingMaskIntoConstraints = false

			// Check if collapsible
			var	button :NSButton? = nil
			if collapsible {
				// Add button
				button = NSButton(frame: NSRect(x: 0.0, y: 0.0, width: 13.0, height: 13.0))
				button!.bezelStyle = .disclosure
				button!.setButtonType(.pushOnPushOff)
				button!.title = ""
				button!.state = .on
				button!.target = self
				button!.action = #selector(toggleItemVisibility(_:))

				addSubview(button!)
				button!.alignLeading(to: self)
			}

			// Add title
			self.titleLabel = AKTLabel()
			self.titleLabel.stringValue = title
			self.titleLabel.font = NSFont.boldSystemFont(ofSize: 12.0)

			addSubview(self.titleLabel)
			self.titleLabel.alignTop(to: self)
			if button != nil {
				// Space horizontally from button
				self.titleLabel.spaceHorizontally(from: button!)
				button!.alignCenterY(to: self.titleLabel)
			} else {
				// Align with view
				self.titleLabel.alignLeading(to: self)
			}
			self.titleLabel.alignTrailing(lessThanOrEqualTo: self)

			// Update
			self.bottomView = self.titleLabel
		}

		//--------------------------------------------------------------------------------------------------------------
		@objc init(view :NSView, leadingInset :CGFloat = 20.0, trailingInset :CGFloat = 0.0) {
			// Store
			self.itemLeadingInset = leadingInset
			self.itemTrailingInset = trailingInset

			// Do super
			super.init(frame: .zero)

			// Setup for content
			self.translatesAutoresizingMaskIntoConstraints = false

			// Add view
			addSubview(view)
			view.alignTop(to: self)
			view.alignLeading(to: self, constant: self.itemLeadingInset)
			view.alignTrailing(lessThanOrEqualTo: self, constant: self.itemTrailingInset)

			// Update
			self.bottomView = view
		}

		//--------------------------------------------------------------------------------------------------------------
		required init?(coder :NSCoder) { fatalError("init(coder:) has not been implemented") }

		// MARK: Instance methods
		//--------------------------------------------------------------------------------------------------------------
		@objc (addView:)
		func add(view :NSView) {
			// Add
			addSubview(view)
			view.spaceVertically(from: self.bottomView)
			view.alignLeading(to: self, constant: self.itemLeadingInset)

			// Update
			self.bottomView = view
		}

		//--------------------------------------------------------------------------------------------------------------		//--------------------------------------------------------------------------------------------------------------
		@objc (addView:leadingInset:)
		func add(view :NSView, leadingInset :CGFloat) {
			// Add
			addSubview(view)
			view.spaceVertically(from: self.bottomView)
			view.alignLeading(to: self, constant: self.itemLeadingInset + leadingInset)

			// Update
			self.bottomView = view
		}

		//--------------------------------------------------------------------------------------------------------------
		@objc (addView:leadingInset:trailingInset:)
		func add(view :NSView, leadingInset :CGFloat, trailingInset :CGFloat) {
			// Add
			addSubview(view)
			view.spaceVertically(from: self.bottomView)
			view.alignLeading(to: self, constant: self.itemLeadingInset + leadingInset)
			view.alignTrailing(lessThanOrEqualTo: self, constant: self.itemTrailingInset + trailingInset)
			view.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)
			view.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)

			// Update
			self.bottomView = view
		}

		//--------------------------------------------------------------------------------------------------------------
		@objc func addItem(title :String, view :NSView, viewLeadingInset :CGFloat = 20.0,
				viewTrailingInset :CGFloat = 0.0) {
			// Add title
			let	titleLabel = AKTLabel()
			titleLabel.stringValue = title
			add(view: titleLabel)

			// Add view
			add(view: view, leadingInset: viewLeadingInset, trailingInset: viewTrailingInset)
		}

		//--------------------------------------------------------------------------------------------------------------
		@objc func addItem(title :String, stringValue :String, valueLeadingInset :CGFloat = 20.0,
				valueTrailingInset :CGFloat = 0.0) {
			// Add title
			let	titleLabel = AKTLabel()
			titleLabel.stringValue = title
			add(view: titleLabel)

			// Add value
			let	valueLabel = AKTLabel()
			valueLabel.stringValue = stringValue
			valueLabel.isSelectable = true
			add(view: valueLabel, leadingInset: valueLeadingInset, trailingInset: valueTrailingInset)
		}

		// MARK: Obj-C methods
		//--------------------------------------------------------------------------------------------------------------
		@objc func toggleItemVisibility(_ sender :NSButton) {
			// Update Layout Constraints
			NSAnimationContext.current.duration = 0.1

			// Update
			if sender.state == .on {
				// Show
				self.bottomViewAsBottomLayoutConstraint.animator().constant = 0.0
			} else {
				// Hide
				self.bottomViewAsBottomLayoutConstraint.animator().constant =
						self.bounds.height - self.titleLabel.bounds.height
			}
		}

		// MARK: Fileprivate methods
		//--------------------------------------------------------------------------------------------------------------
		fileprivate func finalizeLayout() {
			// Add final layout constraint
			self.bottomViewAsBottomLayoutConstraint = self.bottomView.alignBottom(to: self)
		}
	}

	// MARK: Properties
	@objc			var	contentInsets = NSEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
	@objc			var	groupSpacing :CGFloat = 8.0

			private	var	notifcationObserver :NSObjectProtocol?

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	deinit {
		// Cleanup
		if self.notifcationObserver != nil { NotificationCenter.default.removeObserver(self.notifcationObserver!) }
	}

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc func setContent(groupViews :[GroupView]) {
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

		let contentView = NSView()
		scrollView.documentView = contentView
		contentView.alignLeading(to: clipView)
		let	layoutConstraint = contentView.alignTrailing(equalTo: clipView)
		contentView.alignTop(to: clipView)

		// Iterate groups
		var	previousView :NSView? = nil
		groupViews.forEach() {
			// Finalize layout of GroupView
			$0.finalizeLayout()

			// Add GroupView
			contentView.addSubview($0)
			$0.alignLeading(to: contentView, constant: self.contentInsets.left)
			$0.alignTrailing(equalTo: contentView, constant: -self.contentInsets.right)
			if previousView != nil {
				// Have previous view
				$0.spaceVertically(from: previousView!, constant: self.groupSpacing)
			} else {
				// Don't have previous view
				$0.alignTop(to: contentView, constant: self.contentInsets.top)
			}

			// Update
			previousView = $0
		}

		// Finalize
		previousView?.alignBottom(to: contentView, constant: -self.contentInsets.bottom)
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
		let	label = AKTLabel()
		label.stringValue = string
		label.alignment = .center

		self.addSubview(label)
		label.center(in: self)
		label.match(widthOf: self)
	}

	// MARK: Private methods
	//------------------------------------------------------------------------------------------------------------------
	private func updateLayoutConstraint(scrollView :NSScrollView, layoutConstraint :NSLayoutConstraint) {
		DispatchQueue.main.async() { [unowned scrollView, unowned layoutConstraint] in
			// Update layout constraint
			NSAnimationContext.current.duration = 0.1
			layoutConstraint.animator().constant =
					!(scrollView.verticalScroller?.isHidden ?? true) ?
							-scrollView.verticalScroller!.bounds.size.width : 0.0
 		}
	}
}
