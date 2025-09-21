//----------------------------------------------------------------------------------------------------------------------
//	AKTStackView.swift		©2024 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTStackView
class AKTStackView : NSStackView {

	// MARK: Properties
	@objc	var	viewControllers = [NSViewController]()

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	func add(viewController :NSViewController, in gravity :NSStackView.Gravity) {
		// Add to array
		self.viewControllers.append(viewController)

		// Add view
		addView(viewController.view, in: gravity)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(addViewControllerInGravityTop:)
	func addInGravityTop(viewController :NSViewController) {
		// Add in top gravity
		add(viewController: viewController, in: .top)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(addViewControllerInGravityLeading:)
	func addInGravityLeading(viewController :NSViewController) {
		// Add in leading gravity
		add(viewController: viewController, in: .leading)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(addViewControllerInGravityCenter:)
	func addInGravityCenter(viewController :NSViewController) {
		// Add in center gravity
		add(viewController: viewController, in: .center)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(addViewControllerInGravityBottom:)
	func addInGravityBottom(viewController :NSViewController) {
		// Add in bottom gravity
		add(viewController: viewController, in: .bottom)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(addViewControllerInGravityTrailing:)
	func addInGravityTrailing(viewController :NSViewController) {
		// Add in trailing gravity
		add(viewController: viewController, in: .trailing)
	}

	//------------------------------------------------------------------------------------------------------------------
	func insert(viewController :NSViewController, at index :Int, in gravity :NSStackView.Gravity) {
		// Insert into array
		self.viewControllers.insert(viewController, at: index)

		// Insert view
		insertView(viewController.view, at: index, in: gravity)
	}

	//------------------------------------------------------------------------------------------------------------------
	func insertSorted(viewController :NSViewController, in gravity :NSStackView.Gravity,
			sortKeyProc :(_ viewController :NSViewController) -> String) {
		// Setup
		let	viewControllerSortKey = sortKeyProc(viewController)

		// Iterate existing view controllers
		for info in self.viewControllers.enumerated() {
			// Test this one
			if viewControllerSortKey < sortKeyProc(info.element) {
				// Insert at this index
				insert(viewController: viewController, at: info.offset, in: gravity)

				return
			}
		}

		// Insert at the end
		add(viewController: viewController, in: gravity)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(insertViewControllerFillingWidth:sortKeyProc:)
	func insertFillingWidth(viewController :NSViewController,
			sortKeyProc :(_ viewController :NSViewController) -> String) {
		// Insert
		insertSorted(viewController: viewController, in: .center, sortKeyProc: sortKeyProc)
		viewController.view.alignLeading(to: self)
		viewController.view.alignTrailing(to: self)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(removeViewController:)
	func remove(viewController :NSViewController) {
		// Remove
		self.viewControllers.remove(viewController)

		// Remove view
		removeView(viewController.view)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc
	func removeAllViewControllers() {
		// Remove
		self.viewControllers.removeAll()

		// Remove views
		setViews([], in: .center)
	}

	//------------------------------------------------------------------------------------------------------------------
	func set(viewControllers :[NSViewController], in gravity :NSStackView.Gravity) {
		// Update array
		self.viewControllers = viewControllers

		// Update views
		setViews(viewControllers.map({ $0.view }), in: gravity)
	}
}
