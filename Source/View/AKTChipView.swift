//----------------------------------------------------------------------------------------------------------------------
//	AKTChipView.swift			©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTChipView
public class AKTChipView : NSView {

	// MARK: Info
	@objc(AKTChipViewInfo)
	public class Info : NSObject {

		// MARK: Style
		@objc(AKTChipViewInfoStyle)
		public enum Style :Int {
			case outlined
			case filled
		}

		// MARK: Symbol
		@objc(AKTChipViewInfoSymbol)
		public enum Symbol :Int {
			case none
			case locked
		}

		// MARK: Properties
		@objc	public	let	text :String
		@objc	public	let	style :Style
		@objc	public	let	symbol :Symbol

		// MARK: Lifecycle methods
		//--------------------------------------------------------------------------------------------------------------
		@objc public init(text :String, style :Style, symbol :Symbol = .none) {
			// Store
			self.text = text
			self.style = style
			self.symbol = symbol

			// Do super
			super.init()
		}

		// MARK: NSObject methods
		//--------------------------------------------------------------------------------------------------------------
		public override func isEqual(_ object :Any?) -> Bool {
			// Compare
			guard let other = object as? Info else { return false }

			return (other.text == self.text) && (other.style == self.style) && (other.symbol == self.symbol)
		}

		//--------------------------------------------------------------------------------------------------------------
		public override var hash :Int {
			// Must agree with isEqual(_:)
			var	hasher = Hasher()
			hasher.combine(self.text)
			hasher.combine(self.style)
			hasher.combine(self.symbol)

			return hasher.finalize()
		}
	}

	// MARK: Properties
	@objc	public	var	info :Info? {
								didSet {
									// Check if changed
									if self.info != oldValue {
										// Update
										updateContent()
									}
								}
							}

			private	let	textField = NSTextField(labelWithString: "")
			private	let	imageView = NSImageView()
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
	public override func updateLayer() {
		// Setup
		let	isFilled = (self.info?.style ?? .outlined) == .filled

		self.layer?.cornerRadius = self.bounds.height / 2.0
		self.layer?.borderWidth = 1.0
		self.layer?.borderColor = NSColor.tertiaryLabelColor.cgColor
		self.layer?.backgroundColor = isFilled ? NSColor.quaternaryLabelColor.cgColor : NSColor.clear.cgColor
	}

	//------------------------------------------------------------------------------------------------------------------
	public override var wantsUpdateLayer :Bool { true }

	// MARK: Private methods
	//------------------------------------------------------------------------------------------------------------------
	private func setup() {
		// Setup self
		self.wantsLayer = true
		self.translatesAutoresizingMaskIntoConstraints = false
		setContentHuggingPriority(.defaultHigh, for: .horizontal)
		setContentCompressionResistancePriority(.required, for: .horizontal)

		// Setup Image View
		self.imageView.translatesAutoresizingMaskIntoConstraints = false
		self.imageView.isHidden = true
		self.imageView.contentTintColor = .secondaryLabelColor

		// Setup Text Field
		self.textField.translatesAutoresizingMaskIntoConstraints = false
		self.textField.font = .monospacedDigitSystemFont(ofSize: NSFont.smallSystemFontSize, weight: .regular)
		self.textField.textColor = .labelColor
		self.textField.lineBreakMode = .byClipping

		// Setup Stack View
		self.stackView.orientation = .horizontal
		self.stackView.alignment = .centerY
		self.stackView.spacing = 3.0
		self.stackView.addArrangedSubview(self.textField)
		self.stackView.addArrangedSubview(self.imageView)
		addSubview(self.stackView)

		self.stackView.alignLeading(to: self, constant: 6.0)
		self.stackView.alignTrailing(to: self, constant: -6.0)
		self.stackView.alignTop(to: self, constant: 2.0)
		self.stackView.alignBottom(to: self, constant: -2.0)
	}

	//------------------------------------------------------------------------------------------------------------------
	private func updateContent() {
		// Update Text Field
		self.textField.stringValue = self.info?.text ?? ""

		// Update Image View
		switch self.info?.symbol ?? .none {
			case .locked:
				// Locked
				self.imageView.image = NSImage(systemSymbolName: "lock.fill", accessibilityDescription: nil)
				self.imageView.isHidden = false

			case .none:
				// Nothing to show
				self.imageView.image = nil
				self.imageView.isHidden = true
		}

		self.needsDisplay = true
	}
}
