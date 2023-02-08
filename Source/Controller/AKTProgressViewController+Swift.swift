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
		progress.messageUpdatedProc = { [unowned self] in self.updateMessage($0) }
		progress.valueUpdatedProc = { [unowned self] in self.updateValue($0) }

		// Set cancel proc
		self.cancelProc = cancelProc

		// Update UI
		updateMessage(progress.message)
		updateValue(progress.value)
	}

	// MARK: Private methods
	//------------------------------------------------------------------------------------------------------------------
	private func updateMessage(_ message :String) { self.messageLabel.stringValue = message }

	//------------------------------------------------------------------------------------------------------------------
	private func updateValue(_ value :Float?) {
		// Update progress indicator view
		self.progressIndicator.isIndeterminate = value == nil
		self.progressIndicator.doubleValue = Double(value ?? 0.0)
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
