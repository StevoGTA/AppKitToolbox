//----------------------------------------------------------------------------------------------------------------------
//	AKTViewController.swift		©2020 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit
import Carbon.HIToolbox

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTViewController
open class AKTViewController : NSViewController {

	// MARK: Types
	public struct Key {
		// Values
		static	public	let	capsLock = Key(kVK_CapsLock)
		static	public	let	command = Key(kVK_Command)
		static	public	let	control = Key(kVK_Control)
		static	public	let	delete = Key(kVK_Delete)
		static	public	let	downArrow = Key(kVK_DownArrow)
		static	public	let	end = Key(kVK_End)
		static	public	let	escape = Key(kVK_Escape)
		static	public	let	f1 = Key(kVK_F1)
		static	public	let	f2 = Key(kVK_F2)
		static	public	let	f3 = Key(kVK_F3)
		static	public	let	f4 = Key(kVK_F4)
		static	public	let	f5 = Key(kVK_F5)
		static	public	let	f6 = Key(kVK_F6)
		static	public	let	f7 = Key(kVK_F7)
		static	public	let	f8 = Key(kVK_F8)
		static	public	let	f9 = Key(kVK_F9)
		static	public	let	f10 = Key(kVK_F10)
		static	public	let	f11 = Key(kVK_F11)
		static	public	let	f12 = Key(kVK_F12)
		static	public	let	f13 = Key(kVK_F13)
		static	public	let	f14 = Key(kVK_F14)
		static	public	let	f15 = Key(kVK_F15)
		static	public	let	f16 = Key(kVK_F16)
		static	public	let	f17 = Key(kVK_F17)
		static	public	let	f18 = Key(kVK_F18)
		static	public	let	f19 = Key(kVK_F19)
		static	public	let	f20 = Key(kVK_F20)
		static	public	let	forwardDelete = Key(kVK_ForwardDelete)
		static	public	let	function = Key(kVK_Function)
		static	public	let	help = Key(kVK_Help)
		static	public	let	home = Key(kVK_Home)
		static	public	let	leftArrow = Key(kVK_LeftArrow)
		static	public	let	mute = Key(kVK_Mute)
		static	public	let	option = Key(kVK_Option)
		static	public	let	pageDown = Key(kVK_PageDown)
		static	public	let	pageUp = Key(kVK_PageUp)
		static	public	let	`return` = Key(kVK_Return)
		static	public	let	rightArrow = Key(kVK_RightArrow)
		static	public	let	rightCommand = Key(kVK_RightCommand)
		static	public	let	rightControl = Key(kVK_RightControl)
		static	public	let	rightOption = Key(kVK_RightOption)
		static	public	let	rightShift = Key(kVK_RightShift)
		static	public	let	shift = Key(kVK_Shift)
		static	public	let	space = Key(kVK_Space)
		static	public	let	tab = Key(kVK_Tab)
		static	public	let	upArrow = Key(kVK_UpArrow)
		static	public	let	volumeDown = Key(kVK_VolumeDown)
		static	public	let	volumeUp = Key(kVK_VolumeUp)

		// MARK:  Properties
		fileprivate	let	value :Int

		// MARK: Lifecycle methods
		//--------------------------------------------------------------------------------------------------------------
		init(_ value :Int) { self.value = value }
	}

	// MARK: Properties
	private	var	presentErrorCompletionProc :(() -> Void)? = nil

	private	var	eventMonitors = [Any]()
	private	var	notificationObservers = [NSObjectProtocol]()

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	deinit {
		// Cleanup
		self.eventMonitors.forEach() { NSEvent.removeMonitor($0) }
		self.notificationObservers.forEach() { NotificationCenter.default.removeObserver($0) }
	}

	// MARK: Instance methods
	//------------------------------------------------------------------------------------------------------------------
	public func addHandler(for keys :[Key], handlerProc :@escaping (_ key :Key) -> Bool) {
		// Add handler
		if let eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: { [unowned self] in
			// Ensure we are key window
			guard self.view.window == NSApplication.shared.keyWindow else { return $0 }

			// Iterate keys
			for key in keys {
				// Check key
				if key.value == Int($0.keyCode) {
					// Match
					return handlerProc(key) ? nil : $0
				}
			}

			return $0
		}) {
			// Add
			self.eventMonitors.append(eventMonitor)
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	public func present(error :Error, completionProc :@escaping () -> Void = {}) {
		// Store
		self.presentErrorCompletionProc = completionProc

		// Present error
		presentError(error, modalFor: self.view.window!, delegate: self,
				didPresent: #selector(didPresentError(didRecover:contextInfo:)), contextInfo: nil)
	}

	//------------------------------------------------------------------------------------------------------------------
	public func addNotificationObserver(forName name :NSNotification.Name, object :Any? = nil,
			queue :OperationQueue? = nil, proc :@escaping (Notification) -> Void) {
		// Add
		self.notificationObservers.append(
				NotificationCenter.default.addObserver(forName: name, object: object, queue: queue, using: proc))
	}

	// MARK: Private methods
	//------------------------------------------------------------------------------------------------------------------
	@objc private func didPresentError(didRecover :Bool, contextInfo :UnsafeMutableRawPointer?) {
		// Call proc
		self.presentErrorCompletionProc?()
	}
}
