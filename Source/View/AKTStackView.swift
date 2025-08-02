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
	@objc(addViewControllerInGravityCenter:)
	func addInGravityCenter(viewController :NSViewController) {
		// Add in center
		add(viewController: viewController, in: .center)
	}

	//------------------------------------------------------------------------------------------------------------------
	func insert(viewController :NSViewController, at index :Int, in gravity :NSStackView.Gravity) {
		// Insert into array
		self.viewControllers.insert(viewController, at: index)

		// Insert view
		insertView(viewController.view, at: index, in: gravity)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(insertViewControllerInGravityCenter:atIndex:)
	func insertInGravityCenter(viewController :NSViewController, at index :Int) {
		// Insert
		insert(viewController: viewController, at: index, in: .center)
	}

	//------------------------------------------------------------------------------------------------------------------
	func insertSorted(viewContrller :NSViewController, in gravity :NSStackView.Gravity,
			titleProc :(_ viewController :NSViewController) -> String) {
		// Setup
		let	viewControllerTitle = titleProc(viewContrller)

		// Iterate existing view controllers
		for info in self.viewControllers.enumerated() {
			// Test this one
			if viewControllerTitle < titleProc(info.element) {
				// Insert at this index
				insert(viewController: viewContrller, at: info.offset, in: gravity)

				return
			}
		}

		// Insert at the end
		add(viewController: viewContrller, in: gravity)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(insertViewControllerSortedInGravityCenter:titleProc:)
	func insertSortedInGravityCenter(viewContrller :NSViewController,
			titleProc :(_ viewController :NSViewController) -> String) {
		// Insert
		insertSorted(viewContrller: viewContrller, in: .center, titleProc: titleProc)
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

	//------------------------------------------------------------------------------------------------------------------
	@objc(setViewControllersInGravityCenter:)
	func setInGravityCenter(viewControllers :[NSViewController]) {
		// Set in center
		set(viewControllers: viewControllers, in: .center)
	}
}
