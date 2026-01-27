//----------------------------------------------------------------------------------------------------------------------
//	AKTDynamicStackViewHelper.swift			©2025 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTDynamicStackViewHelper
@MainActor
public class AKTDynamicStackViewHelper : NSObject {

	// MARK: Procs
	public typealias CreateRemovableViewControllerProc = () -> AKTRemovableViewController

	// MARK: Properties
	@objc
	public		var	minViewControllers = 1

	@objc
	public		var	maxViewControllers = 10

	@objc
	public		var	viewControllers :[NSViewController] { self.stackView?.viewControllers ?? [] }

	@objc
	public		var	contentChangedProc :() -> Void = {}

	@objc
	public		var	createRemovableViewControllerProc :CreateRemovableViewControllerProc!

	@IBOutlet	var	stackView :AKTStackView!
	@IBOutlet	var	addButton :NSButton!

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	@objc func setup() {
		// Setup
		self.addButton?.actionProc = { [unowned self] _ in self.add(self.createRemovableViewControllerProc()) }
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc
	public func add(_ removableViewController :AKTRemovableViewController) {
		// Setup
		removableViewController.removeProc = { [unowned self] in
			// Remove
			self.stackView.remove(viewController: removableViewController)

			// Update UI
			self.updateUI()

			// Call proc
			self.contentChangedProc()
		}

		// Add
		self.stackView.add(viewController: removableViewController, in: .center)

		// Update UI
		self.updateUI()

		// Call proc
		self.contentChangedProc()
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc
	public func ensureMinimum() {
		// Add view controllers to reach minimum
		while self.stackView.viewControllers.count < self.minViewControllers {
			// Add
			self.add(self.createRemovableViewControllerProc())
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	@objc
	public func removeAll() {
		// Remove all
		self.stackView.set(viewControllers: [], in: .center)

		// Update UI
		updateUI()

		// Call proc
		self.contentChangedProc()
	}

	// MARK: Private methods
	//------------------------------------------------------------------------------------------------------------------
	private func updateUI() {
		// Update UI
		self.addButton.isEnabled = self.stackView.viewControllers.count < self.maxViewControllers

		self.stackView.viewControllers.forEach() {
			// Update Remove button
			($0 as! AKTRemovableViewController).setRemoveButtonEnabled(
					self.stackView.viewControllers.count > self.minViewControllers)
		}
	}
}
