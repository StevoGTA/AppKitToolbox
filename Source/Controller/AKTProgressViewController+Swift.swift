//----------------------------------------------------------------------------------------------------------------------
//	AKTProgressViewController+Swift.swift			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import Foundation

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTProgressViewController extension
public extension AKTProgressViewController {

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	func setup(progress :Progress, cancelProc :CancelProc? = nil) {
		// Setup
		progress.updatedProc = { [unowned self] in self.updateUI($0) }

		// Set cancel proc
		self.cancelProc = cancelProc

		// Update UI
		updateUI(progress)
	}

	// MARK: Private methods
	//------------------------------------------------------------------------------------------------------------------
	private func updateUI(_ progress :Progress) {
		// Update UI
		self.messageLabel.stringValue = progress.message

		self.progressIndicator.isIndeterminate = progress.value == nil
		self.progressIndicator.doubleValue = progress.value ?? 0.0
		if progress.value != nil {
			// Have value
			self.progressIndicator.stopAnimation(self)
		} else {
			// Don't have value
			self.progressIndicator.startAnimation(self)
		}
	}
}

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTViewController extension
public extension AKTViewController {

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	func perform<T>(progress :Progress, progressViewController :AKTProgressViewController,
			procDispatchQueue :DispatchQueue = DispatchQueue.global(),
			proc :@escaping () throws -> T, cancelProc :(() -> Void)? = nil,
			completionProc :@escaping (_ result :T?, _ error :Error?) -> Void = { _,_ in }) {
		// Setup
		var	isCancelled = false
		if cancelProc != nil {
			// Have cancelProc
			progressViewController.setup(progress: progress, cancelProc: {
				// Cancelled
				isCancelled = true

				// Call proc
				cancelProc!()
			})
		} else {
			// Don't have cancelProc
			progressViewController.setup(progress: progress)
		}

		// Present progress view controller as sheet
		presentAsSheet(progressViewController)

		// Jump to procs queue
		procDispatchQueue.async() {
			// Call proc
			var	result :T? = nil
			var	procError :Error? = nil
			do { try result = proc() } catch { procError = error }

			// Jump to main queue
			DispatchQueue.main.async() {
				// Update UI
				self.dismiss(progressViewController)

				// Check cancelled
				if !isCancelled {
					// Call completion proc
					completionProc(result, procError)
				}
			}
		}
	}

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	func perform(progress :Progress, progressViewController :AKTProgressViewController,
			procDispatchQueue :DispatchQueue = DispatchQueue.global(),
			proc :@escaping () throws -> Void, cancelProc :(() -> Void)? = nil,
			completionProc :@escaping (_ error :Error?) -> Void = { _ in }) {
		// Setup
		var	isCancelled = false
		if cancelProc != nil {
			// Have cancelProc
			progressViewController.setup(progress: progress, cancelProc: {
				// Cancelled
				isCancelled = true

				// Call proc
				cancelProc!()
			})
		} else {
			// Don't have cancelProc
			progressViewController.setup(progress: progress)
		}

		// Present progress view controller as sheet
		presentAsSheet(progressViewController)

		// Jump to procs queue
		procDispatchQueue.async() {
			// Call proc
			var	procError :Error? = nil
			do { try proc() } catch { procError = error }

			// Jump to main queue
			DispatchQueue.main.async() {
				// Update UI
				self.dismiss(progressViewController)

				// Check cancelled
				if !isCancelled {
					// Call completion proc
					completionProc(procError)
				}
			}
		}
	}
}
