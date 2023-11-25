//----------------------------------------------------------------------------------------------------------------------
//	AKTGroupView.swift			©2023 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTGroupView
public class AKTGroupView : NSView {

	// MARK: Properties
	private		let	itemLeadingInset :CGFloat
	private		let	itemTrailingInset :CGFloat?

	private		var	bottomView :NSView!
	fileprivate	var	bottomViewAsBottomLayoutConstraint :NSLayoutConstraint!

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
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
		view.alignTrailing(lessThanOrEqualTo: self, constant: self.itemTrailingInset!)

		// Update
		self.bottomView = view
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc init(view :NSView, leadingInset :CGFloat = 20.0) {
		// Store
		self.itemLeadingInset = leadingInset
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
		self.bottomView = view
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc init(titleView :NSView, itemLeadingInset :CGFloat = 20.0, itemTrailingInset :CGFloat = 0.0) {
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
		self.bottomView = titleView
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc init(titleView :NSView, itemLeadingInset :CGFloat = 20.0) {
		// Store
		self.itemLeadingInset = itemLeadingInset
		self.itemTrailingInset = nil

		// Do super
		super.init(frame: .zero)

		// Setup for content
		self.translatesAutoresizingMaskIntoConstraints = false

		// Add view
		addSubview(titleView)
		titleView.alignTop(to: self)
		titleView.alignLeading(to: self)

		// Update
		self.bottomView = titleView
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc convenience init(title :String, itemLeadingInset :CGFloat = 20.0, itemTrailingInset :CGFloat = 0.0) {
		// Setup title
		let	label = AKTLabel()
		label.stringValue = title
		label.font = NSFont.boldSystemFont(ofSize: 12.0)

		// Init
		self.init(titleView: label, itemLeadingInset: itemLeadingInset, itemTrailingInset: itemTrailingInset)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc convenience init(title :String, itemLeadingInset :CGFloat = 20.0) {
		// Setup title
		let	label = AKTLabel()
		label.stringValue = title
		label.font = NSFont.boldSystemFont(ofSize: 12.0)

		// Init
		self.init(titleView: label, itemLeadingInset: itemLeadingInset)
	}

	//------------------------------------------------------------------------------------------------------------------
	required init?(coder :NSCoder) { fatalError("init(coder:) has not been implemented") }

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc (addView:)
	func add(view :NSView) {
		// Add
		addSubview(view)
		view.spaceVertically(from: self.bottomView)
		view.alignLeading(to: self, constant: self.itemLeadingInset)
		if let itemTrailingInset = self.itemTrailingInset {
			// Add trailing constraint
			view.alignTrailing(lessThanOrEqualTo: self, constant: itemTrailingInset)

			// Set priorities
			view.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)
			view.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)
		}

		// Update
		self.bottomView = view
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc (addView:leadingInset:)
	func add(view :NSView, leadingInset :CGFloat) {
		// Add
		addSubview(view)
		view.spaceVertically(from: self.bottomView)
		view.alignLeading(to: self, constant: self.itemLeadingInset + leadingInset)

		// Update
		self.bottomView = view
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc (addView:leadingInset:trailingInset:)
	func add(view :NSView, leadingInset :CGFloat, trailingInset :CGFloat) {
		// Add
		addSubview(view)
		view.spaceVertically(from: self.bottomView)
		view.alignLeading(to: self, constant: self.itemLeadingInset + leadingInset)
		view.alignTrailing(lessThanOrEqualTo: self, constant: (self.itemTrailingInset ?? 0.0) + trailingInset)
		view.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)
		view.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)

		// Update
		self.bottomView = view
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func addItem(title :String, view :NSView, viewLeadingInset :CGFloat = 20.0,
			viewTrailingInset :CGFloat = 0.0) {
		// Add title
		let	titleLabel = AKTLabel()
		titleLabel.stringValue = title
		add(view: titleLabel)

		// Add view
		add(view: view, leadingInset: viewLeadingInset, trailingInset: viewTrailingInset)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc func addItem(title :String, string :String, valueLeadingInset :CGFloat = 20.0,
			valueTrailingInset :CGFloat = 0.0) {
		// Add title
		let	titleLabel = AKTLabel()
		titleLabel.stringValue = title
		add(view: titleLabel)

		// Add value
		let	valueLabel = AKTLabel()
		valueLabel.stringValue = string
		valueLabel.isSelectable = true
		add(view: valueLabel, leadingInset: valueLeadingInset, trailingInset: valueTrailingInset)
	}

	//--------------------------------------------------------------------------------------------------------------
	func finalizeLayout() {
		// Add final layout constraint
		self.bottomViewAsBottomLayoutConstraint = self.bottomView.alignBottom(to: self)
	}
}

//----------------------------------------------------------------------------------------------------------------------
// MARK: - AKTCollapsibleGroupView
public class AKTCollapsibleGroupView : AKTGroupView {

	// MARK: Properties
	private	let	titleLabel :AKTLabel

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	@objc init(title :String, itemLeadingInset :CGFloat = 20.0, itemTrailingInset :CGFloat = 0.0) {
		// Compose button
		let	button = NSButton(frame: NSRect(x: 0.0, y: 0.0, width: 13.0, height: 13.0))
		button.bezelStyle = .disclosure
		button.setButtonType(.pushOnPushOff)
		button.title = ""
		button.state = .on

		// Compose title
		self.titleLabel = AKTLabel()
		self.titleLabel.stringValue = title
		self.titleLabel.font = NSFont.boldSystemFont(ofSize: 12.0)

		// Compose title view
		let	view = NSView()
		view.addSubview(button)
		view.addSubview(self.titleLabel)

		button.alignLeading(to: view)
		self.titleLabel.spaceHorizontally(from: button, constant: 8.0)
		self.titleLabel.alignTrailing(equalTo: view)

		self.titleLabel.alignCenterY(to: button)
		self.titleLabel.alignTop(to: view)
		self.titleLabel.alignBottom(to: view)

		// Do super
		super.init(titleView: view, itemLeadingInset: itemLeadingInset, itemTrailingInset: itemTrailingInset)

		// Finish setup
		button.actionProc = { [unowned self, button] _ in
			// Update Layout Constraints
			NSAnimationContext.current.duration = 0.1

			// Update
			if button.state == .on {
				// Show
				self.bottomViewAsBottomLayoutConstraint.animator().constant = 0.0
			} else {
				// Hide
				self.bottomViewAsBottomLayoutConstraint.animator().constant =
						self.bounds.height - self.titleLabel.bounds.height
			}
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc init(title :String, itemLeadingInset :CGFloat = 20.0) {
		// Compose button
		let	button = NSButton(frame: NSRect(x: 0.0, y: 0.0, width: 13.0, height: 13.0))
		button.bezelStyle = .disclosure
		button.setButtonType(.pushOnPushOff)
		button.title = ""
		button.state = .on

		// Compose title
		self.titleLabel = AKTLabel()
		self.titleLabel.stringValue = title
		self.titleLabel.font = NSFont.boldSystemFont(ofSize: 12.0)

		// Compose title view
		let	view = NSView()
		view.addSubview(button)
		view.addSubview(self.titleLabel)

		button.alignLeading(to: view)
		self.titleLabel.spaceHorizontally(from: button, constant: 8.0)
		self.titleLabel.alignTrailing(equalTo: view)

		self.titleLabel.alignCenterY(to: button)
		self.titleLabel.alignTop(to: view)
		self.titleLabel.alignBottom(to: view)

		// Do super
		super.init(titleView: view, itemLeadingInset: itemLeadingInset)

		// Finish setup
		button.actionProc = { [unowned self, button] _ in
			// Update Layout Constraints
			NSAnimationContext.current.duration = 0.1

			// Update
			if button.state == .on {
				// Show
				self.bottomViewAsBottomLayoutConstraint.animator().constant = 0.0
			} else {
				// Hide
				self.bottomViewAsBottomLayoutConstraint.animator().constant =
						self.bounds.height - self.titleLabel.bounds.height
			}
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	required init?(coder :NSCoder) { fatalError("init(coder:) has not been implemented") }
}
