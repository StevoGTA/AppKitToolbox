//----------------------------------------------------------------------------------------------------------------------
//	AKTGroupView.swift			©2023 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTGroupView
public class AKTGroupView : NSView {

	// MARK: Properties
	override	public		var	isFlipped: Bool { true }

	@objc		public		var	viewTitleControlSize :UInt = UInt(NSControl.ControlSize.regular.rawValue)

				private		let	hasTitle :Bool
				private		let	itemLeadingInset :CGFloat
				private		let	itemTrailingInset :CGFloat?

				private		var	subviewsOrderedVertically :[NSView]
									{ self.subviews.sorted(by: { $0.frame.minY < $1.frame.minY })}

				fileprivate	var	bottomViewBottomLayoutConstraint :NSLayoutConstraint!

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	@objc init(view :NSView, itemLeadingInset :CGFloat = 0.0) {
		// Setup
		self.hasTitle = false

		// Store
		self.itemLeadingInset = itemLeadingInset
		self.itemTrailingInset = nil

		// Do super
		super.init(frame: .zero)

		// Setup for content
		self.translatesAutoresizingMaskIntoConstraints = false

		// Add view
		addSubview(view)
		view.alignTop(to: self)
		view.alignLeading(to: self, constant: self.itemLeadingInset)

		// Update
		self.bottomViewBottomLayoutConstraint = view.alignBottom(to: self)
	}

	//------------------------------------------------------------------------------------------------------------------
	init(titleView :NSView, itemLeadingInset :CGFloat = 0.0, itemTrailingInset :CGFloat? = nil) {
		// Setup
		self.hasTitle = true

		// Store
		self.itemLeadingInset = itemLeadingInset
		self.itemTrailingInset = itemTrailingInset

		// Do super
		super.init(frame: .zero)

		// Setup for content
		self.translatesAutoresizingMaskIntoConstraints = false

		// Add view
		addSubview(titleView)
		titleView.alignTop(to: self)
		titleView.alignLeading(to: self)
		titleView.alignTrailing(lessThanOrEqualTo: self)

		// Update
		self.bottomViewBottomLayoutConstraint = titleView.alignBottom(to: self)
	}

	//------------------------------------------------------------------------------------------------------------------
	required init?(coder :NSCoder) { fatalError("init(coder:) has not been implemented") }

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc(addView:)
	func add(view :NSView) {
		// Insert view
		insert(view: view, atIndex: self.hasTitle ? self.subviews.count - 1 : self.subviews.count)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(addViewIgnoringItemTrailingInset:)
	func add(viewIgnoringItemTrailingInset view :NSView) {
		// Insert view
		insert(viewIgnoringItemTrailingInset: view,
				atIndex: self.hasTitle ? self.subviews.count - 1: self.subviews.count)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(addView:leadingInset:trailingInset:)
	func add(view :NSView, leadingInset :CGFloat, trailingInset :CGFloat) {
		// Insert
		insert(view: view, atIndex: self.hasTitle ? self.subviews.count - 1: self.subviews.count,
				leadingInset: leadingInset, trailingInset: trailingInset)
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc func addView(title :String, view :NSView, viewLeadingInset :CGFloat, viewTrailingInset :CGFloat) -> NSView {
		// Make composite view
		let	containerView = NSView()
		add(view: containerView)

		// Add title label
		let	label = AKTLabel(string: title, controlSize: self.viewTitleControlSize)
		containerView.addSubview(label)
		label.alignTop(to: containerView)
		label.alignLeading(to: containerView)
		if let itemTrailingInset = self.itemTrailingInset {
			// Add trailing constraint
			label.alignTrailing(to: containerView, constant: itemTrailingInset)

			// Set priorities
			label.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)
			label.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)
		}

		// Add view
		containerView.addSubview(view)
		view.spaceVertically(from: label)
		view.alignBottom(to: containerView)
		view.alignLeading(to: containerView, constant: viewLeadingInset)
		view.alignTrailing(to: containerView, constant: viewTrailingInset)
		view.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)
		view.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)

		return containerView
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(insertView:atIndex:)
	func insert(view :NSView, atIndex index :Int) {
		// Setup
		let	subviewsOrderedVertically = self.subviewsOrderedVertically

		// Add
		addSubview(view)
		view.alignLeading(to: self, constant: self.itemLeadingInset)
		if let itemTrailingInset = self.itemTrailingInset {
			// Add trailing constraint
			view.alignTrailing(to: self, constant: itemTrailingInset)

			// Set priorities
			view.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)
			view.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)
		}

		// Layout
		layout(childView: view, atIndex: self.hasTitle ? index + 1 : index, with: subviewsOrderedVertically)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(addViewIgnoringItemTrailingInset:atIndex:)
	func insert(viewIgnoringItemTrailingInset view :NSView, atIndex index :Int) {
		// Setup
		let	subviewsOrderedVertically = self.subviewsOrderedVertically

		// Add
		addSubview(view)
		view.alignLeading(to: self, constant: self.itemLeadingInset)

		// Layout
		layout(childView: view, atIndex: self.hasTitle ? index + 1 : index, with: subviewsOrderedVertically)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(addView:atIndex:leadingInset:trailingInset:)
	func insert(view :NSView, atIndex index :Int, leadingInset :CGFloat, trailingInset :CGFloat) {
		// Setup
		let	subviewsOrderedVertically = self.subviewsOrderedVertically

		// Add
		addSubview(view)
		view.alignLeading(to: self, constant: self.itemLeadingInset + leadingInset)
		view.alignTrailing(to: self, constant: (self.itemTrailingInset ?? 0.0) + trailingInset)
		view.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)
		view.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)

		// Layout
		layout(childView: view, atIndex: self.hasTitle ? index + 1 : index, with: subviewsOrderedVertically)
	}

	//------------------------------------------------------------------------------------------------------------------
	@discardableResult
	@objc func insertItem(title :String, view :NSView, atIndex index :Int, viewLeadingInset :CGFloat,
			viewTrailingInset :CGFloat) -> NSView {
		// Make composite view
		let	containerView = NSView()
		insert(view: containerView, atIndex: index)

		// Add title label
		let	label = AKTLabel(string: title, controlSize: self.viewTitleControlSize)
		containerView.addSubview(label)
		label.alignTop(to: containerView)
		label.alignLeading(to: containerView)
		if let itemTrailingInset = self.itemTrailingInset {
			// Add trailing constraint
			label.alignTrailing(to: containerView, constant: itemTrailingInset)

			// Set priorities
			label.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)
			label.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)
		}

		// Add view
		containerView.addSubview(view)
		view.spaceVertically(from: label)
		view.alignBottom(to: containerView)
		view.alignLeading(to: containerView, constant: viewLeadingInset)
		view.alignTrailing(to: containerView, constant: viewTrailingInset)
		view.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)
		view.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)

		return containerView
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(removeView:)
	func remove(_ view :NSView) {
		// Get index
		let	subviewsOrderedVertically = self.subviewsOrderedVertically
		guard let index = subviewsOrderedVertically.firstIndex(of: view) else { return }

		// Remove view
		view.removeFromSuperview()

		// Check position
		if index == 0 {
			// Top view
			subviewsOrderedVertically[1].alignTop(to: self)
		} else if index < (subviewsOrderedVertically.count - 1) {
			// Middle view
			subviewsOrderedVertically[index + 1].spaceVertically(from: subviewsOrderedVertically[index - 1])
		} else {
			// Bottom view
			self.bottomViewBottomLayoutConstraint = subviewsOrderedVertically[index - 1].alignBottom(to: self)
		}
	}

	// MARK: Private methods
	//------------------------------------------------------------------------------------------------------------------
	private func layout(childView view :NSView, atIndex index :Int, with subviewsOrderedVertically :[NSView]) {
		// Check index
		if index == 0 {
			// Add at top
			if subviewsOrderedVertically.count >  0 {
				// Disconnect the current top view
				NSLayoutConstraint.deactivate(self.constraints(between: self, and: subviewsOrderedVertically.first!))
			}

			// Align this view to top
			view.alignTop(to: self)

			// Check if this is the only view
			if subviewsOrderedVertically.count == 0 {
				// Also align to bottom
				self.bottomViewBottomLayoutConstraint = view.alignBottom(to: self)
			}
		} else if index < subviewsOrderedVertically.count {
			// Add in the middle
			let	aboveView = subviewsOrderedVertically[index - 1]
			let	belowView = subviewsOrderedVertically[index]
			NSLayoutConstraint.deactivate(self.constraints(between: aboveView, and: belowView))

			view.spaceVertically(from: aboveView)
			belowView.spaceVertically(from: view)
		} else {
			// Add at the bottom
			view.spaceVertically(from: subviewsOrderedVertically.last!)

			// Update
			NSLayoutConstraint.deactivate([self.bottomViewBottomLayoutConstraint])
			self.bottomViewBottomLayoutConstraint = view.alignBottom(to: self)
		}
	}
}

//----------------------------------------------------------------------------------------------------------------------
// MARK: - AKTCollapsibleGroupView
public class AKTCollapsibleGroupView : AKTGroupView {

	// MARK: Properties
	private	let	titleView :NSView

	private	var	heightLayoutConstraint :NSLayoutConstraint!
	private	var	isCollapsed = false

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	@objc init(title :String, itemLeadingInset :CGFloat, itemTrailingInset :CGFloat) {
		// Compose button
		let	button = NSButton(frame: NSRect(x: 0.0, y: 0.0, width: 13.0, height: 13.0))
		button.bezelStyle = .disclosure
		button.setButtonType(.pushOnPushOff)
		button.title = ""
		button.state = .on

		// Compose title
		let	titleLabel = AKTLabel(string: title, font: NSFont.boldSystemFont(ofSize: 12.0))

		// Compose title view
		self.titleView = NSView()
		self.titleView.addSubview(button)
		self.titleView.addSubview(titleLabel)

		button.alignLeading(to: self.titleView)
		titleLabel.spaceHorizontally(from: button, constant: 8.0)
		titleLabel.alignTrailing(to: self.titleView)

		titleLabel.alignCenterY(to: button)
		titleLabel.alignTop(to: self.titleView)
		titleLabel.alignBottom(to: self.titleView)

		// Do super
		super.init(titleView: self.titleView, itemLeadingInset: itemLeadingInset, itemTrailingInset: itemTrailingInset)

		// Setup
		self.heightLayoutConstraint = self.heightAnchor.constraint(equalToConstant: 0.0)
		self.heightLayoutConstraint.priority = NSLayoutConstraint.Priority(rawValue: 100)

		// Setup button
		setup(button: button)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc init(title :String, itemLeadingInset :CGFloat) {
		// Compose button
		let	button = NSButton(frame: NSRect(x: 0.0, y: 0.0, width: 13.0, height: 13.0))
		button.bezelStyle = .disclosure
		button.setButtonType(.pushOnPushOff)
		button.title = ""
		button.state = .on

		// Compose title
		let	titleLabel = AKTLabel(string: title, font: NSFont.boldSystemFont(ofSize: 12.0))

		// Compose title view
		self.titleView = NSView()
		self.titleView.addSubview(button)
		self.titleView.addSubview(titleLabel)

		button.alignLeading(to: self.titleView)
		titleLabel.spaceHorizontally(from: button, constant: 8.0)
		titleLabel.alignTrailing(to: self.titleView)

		titleLabel.alignCenterY(to: button)
		titleLabel.alignTop(to: self.titleView)
		titleLabel.alignBottom(to: self.titleView)

		// Do super
		super.init(titleView: self.titleView, itemLeadingInset: itemLeadingInset)

		// Setup
		self.heightLayoutConstraint = self.heightAnchor.constraint(equalToConstant: 0.0)
		self.heightLayoutConstraint.priority = NSLayoutConstraint.Priority(rawValue: 100)

		// Setup button
		setup(button: button)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc init(title :String) {
		// Compose button
		let	button = NSButton(frame: NSRect(x: 0.0, y: 0.0, width: 13.0, height: 13.0))
		button.bezelStyle = .disclosure
		button.setButtonType(.pushOnPushOff)
		button.title = ""
		button.state = .on

		// Compose title
		let	titleLabel = AKTLabel(string: title, font: NSFont.boldSystemFont(ofSize: 12.0))

		// Compose title view
		self.titleView = NSView()
		self.titleView.addSubview(button)
		self.titleView.addSubview(titleLabel)

		button.alignLeading(to: self.titleView)
		titleLabel.spaceHorizontally(from: button, constant: 8.0)
		titleLabel.alignTrailing(to: self.titleView)

		titleLabel.alignCenterY(to: button)
		titleLabel.alignTop(to: self.titleView)
		titleLabel.alignBottom(to: self.titleView)

		// Do super
		super.init(titleView: self.titleView)

		// Setup
		self.heightLayoutConstraint = self.heightAnchor.constraint(equalToConstant: 0.0)
		self.heightLayoutConstraint.priority = NSLayoutConstraint.Priority(rawValue: 100)

		// Setup button
		setup(button: button)
	}

	//------------------------------------------------------------------------------------------------------------------
	required init?(coder :NSCoder) { fatalError("init(coder:) has not been implemented") }

	// MARK: NSView methods
	//------------------------------------------------------------------------------------------------------------------
	public override func setFrameSize(_ newSize :NSSize) {
		// Do super
		super.setFrameSize(newSize)

		// Update height layout constraint
		if !self.isCollapsed {
			// Update
			self.heightLayoutConstraint.constant = newSize.height
		}
	}

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc(setCollapsed:completionProc:)
	func set(collapsed :Bool, completionProc :@escaping () -> Void = {}) {
		// Check if changing
		if collapsed != self.isCollapsed {
			// Set new value
			self.isCollapsed = collapsed

			// Update UI
			self.isCollapsedChanged(completionProc: completionProc)
		} else {
			// Nothing to do, call proc
			completionProc()
		}
	}

	// MARK: Private methods
	//------------------------------------------------------------------------------------------------------------------
	private func setup(button :NSButton) {
		// Setup button
		button.actionProc = { [unowned self] _ in
			// Toggle value
			self.isCollapsed.toggle()

			// Update UI
			self.isCollapsedChanged()
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	private func isCollapsedChanged(completionProc :@escaping () -> Void = {}) {
		// Check action
		if self.isCollapsed {
			// Collapsing
			NSLayoutConstraint.deactivate([self.bottomViewBottomLayoutConstraint])
			NSLayoutConstraint.activate([self.heightLayoutConstraint])
			self.heightLayoutConstraint.animator().constant = self.titleView.bounds.height

			// Update child views
			self.subviews.filter({ $0 != self.titleView }).forEach() { $0.animator().isHidden = true }

			// Setup animation context
			NSAnimationContext.current.completionHandler = completionProc
		} else {
			// Showing
			NSLayoutConstraint.deactivate([self.heightLayoutConstraint])
			NSLayoutConstraint.activate([self.bottomViewBottomLayoutConstraint])

			// Update child views
			self.subviews.filter({ $0 != self.titleView }).forEach() { $0.animator().isHidden = false }

			// Setup animation context
			NSAnimationContext.current.completionHandler = completionProc
		}
	}
}
