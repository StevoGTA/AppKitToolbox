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
	@objc(addViewControllerInGravityCenter:) func addInGravityCenter(viewController :NSViewController) {
		// Add in center
		add(viewController: viewController, in: .center)
	}

	//------------------------------------------------------------------------------------------------------------------
	func set(viewControllers :[NSViewController], in gravity :NSStackView.Gravity) {
		// Update array
		self.viewControllers = viewControllers

		// Update views
		setViews(viewControllers.map({ $0.view }), in: gravity)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(setViewControllersInGravityCenter:) func setInGravityCenter(viewControllers :[NSViewController]) {
		// Set in center
		set(viewControllers: viewControllers, in: .center)
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc(removeViewController:) func remove(viewController :NSViewController) {
		// Remove
		self.viewControllers.remove(viewController)

		// Remove view
		removeView(viewController.view)
	}
}
