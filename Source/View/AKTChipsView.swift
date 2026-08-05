//----------------------------------------------------------------------------------------------------------------------
//	AKTChipsView.swift			©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTChipsView
public class AKTChipsView : NSView {

	// MARK: Properties
	@objc	public	var	infos :[AKTChipView.Info] = [] {
								didSet {
									// Check if changed
									guard self.infos != oldValue else { return }

									// Update
									updateChipViews()
								}
							}

			private	let	stackView = NSStackView()

	// MARK: Lifecycle methods
	//------------------------------------------------------------------------------------------------------------------
	public override init(frame frameRect :NSRect) {
		// Do super
		super.init(frame: frameRect)

		// Setup
		setup()
	}

	//------------------------------------------------------------------------------------------------------------------
	public required init?(coder :NSCoder) {
		// Do super
		super.init(coder: coder)

		// Setup
		setup()
	}

	// MARK: NSView methods
	//------------------------------------------------------------------------------------------------------------------
	public override var isFlipped :Bool { true }

	//------------------------------------------------------------------------------------------------------------------
	public override var intrinsicContentSize :NSSize { self.stackView.fittingSize }

	// MARK: Private methods
	//------------------------------------------------------------------------------------------------------------------
	private func setup() {
		// Setup self
		self.translatesAutoresizingMaskIntoConstraints = false
		setAccessibilityRole(.group)

		// Setup Stack View
		self.stackView.orientation = .horizontal
		self.stackView.alignment = .centerY
		self.stackView.spacing = 4.0
		addSubview(self.stackView)

		self.stackView.match(self)

		// Chips are the payload of the row - the path beside them gives way first
		setContentCompressionResistancePriority(.required, for: .horizontal)
		setContentHuggingPriority(.defaultHigh, for: .horizontal)
	}

	//------------------------------------------------------------------------------------------------------------------
	private func updateChipViews() {
		// Setup
		var	chipViews = self.stackView.arrangedSubviews.compactMap({ $0 as? AKTChipView })

		// Add any chip views needed
		while chipViews.count < self.infos.count {
			// Add one more
			let	chipView = AKTChipView()
			self.stackView.addArrangedSubview(chipView)
			chipViews.append(chipView)
		}

		// Remove any chip views no longer needed
		while chipViews.count > self.infos.count {
			// Remove the last
			let	chipView = chipViews.removeLast()
			self.stackView.removeArrangedSubview(chipView)
			chipView.removeFromSuperview()
		}

		// Update content
		zip(chipViews, self.infos).forEach() { $0.info = $1 }

		// Update intrinsic content size
		invalidateIntrinsicContentSize()
	}
}
