//----------------------------------------------------------------------------------------------------------------------
//	AKTPathView.swift			©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTPathView
public class AKTPathView : NSView {

	// MARK: Types
	private struct SegmentInfo {

		// MARK: Properties
		let	name :String
		let	cumulativePath :String

		let	button :NSButton
		let	chevronTextField :NSTextField?
	}

	// MARK: Properties
	@objc	public	var	rootPath :String? {
								didSet {
									// Check if changed
									guard self.rootPath != oldValue else { return }

									// Update
									rebuildSegments()
								}
							}
	@objc	public	var	path :String = "" {
								didSet {
									// Check if changed
									guard self.path != oldValue else { return }

									// Update
									rebuildSegments()
								}
							}

			private	var	segmentInfos = [SegmentInfo]()
			private	var	fullWidths = [CGFloat]()
			private	var	hoveredIndex :Int?

			private	let	stackView = NSStackView()
			private	var	trackingArea :NSTrackingArea?

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
	public override func updateTrackingAreas() {
		// Do super
		super.updateTrackingAreas()

		// Replace tracking area
		if let trackingArea = self.trackingArea { removeTrackingArea(trackingArea) }

		let	trackingArea =
					NSTrackingArea(rect: self.bounds,
							options: [.activeInKeyWindow, .mouseMoved, .mouseEnteredAndExited], owner: self)
		addTrackingArea(trackingArea)
		self.trackingArea = trackingArea
	}

	//------------------------------------------------------------------------------------------------------------------
	public override func mouseMoved(with event :NSEvent) {
		// Update hovered segment
		let	point = convert(event.locationInWindow, from: nil)
		updateHoveredIndex(self.segmentInfos.firstIndex(where: { $0.button.frame.contains(point) }))
	}

	//------------------------------------------------------------------------------------------------------------------
	public override func mouseExited(with event :NSEvent) { updateHoveredIndex(nil) }

	//------------------------------------------------------------------------------------------------------------------
	public override func layout() {
		// Do super
		super.layout()

		// Decide which segments are shown in full
		updateCollapsedStates()
	}

	// MARK: Private methods
	//------------------------------------------------------------------------------------------------------------------
	private func setup() {
		// Setup self
		self.translatesAutoresizingMaskIntoConstraints = false
		setAccessibilityRole(.group)

		// Setup Stack View
		self.stackView.orientation = .horizontal
		self.stackView.alignment = .centerY
		self.stackView.spacing = 2.0
		addSubview(self.stackView)

		self.stackView.alignLeading(to: self)
		self.stackView.alignTop(to: self)
		self.stackView.alignBottom(to: self)
		self.stackView.alignTrailing(lessThanOrEqualTo: self)

		// The path gives way before anything beside it does
		setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
	}

	//------------------------------------------------------------------------------------------------------------------
	private func rebuildSegments() {
		// Reset
		self.stackView.arrangedSubviews.forEach() {
			// Remove
			self.stackView.removeArrangedSubview($0)
			$0.removeFromSuperview()
		}
		self.segmentInfos = []
		self.fullWidths = []
		self.hoveredIndex = nil

		// Compose the segments to display, keeping the cumulative path for each so a click can reveal it
		let	components = self.path.split(separator: "/", omittingEmptySubsequences: true).map(String.init)
		let	rootComponents =
					(self.rootPath ?? "").split(separator: "/", omittingEmptySubsequences: true).map(String.init)
		let	skipCount = components.starts(with: rootComponents) ? rootComponents.count : 0
		for index in skipCount ..< components.count {
			// Setup
			let	name = components[index]
			let	cumulativePath = "/" + components[0...index].joined(separator: "/")

			// Chevron, for all but the first displayed segment
			var	chevronTextField :NSTextField?
			if index > skipCount {
				// Add chevron
				let	textField = NSTextField(labelWithString: "\u{203A}")
				textField.textColor = .tertiaryLabelColor
				self.stackView.addArrangedSubview(textField)
				chevronTextField = textField
			}

			// Button - capturing the cumulative path, so no lookup is needed when clicked
			let	button =
						NSButton(title: name,
								actionProc: { _ in
									// Reveal in the Finder
									NSWorkspace.shared.activateFileViewerSelecting(
											[URL(fileURLWithPath: cumulativePath)])
								})
			button.isBordered = false
			button.bezelStyle = .inline
			button.contentTintColor = .secondaryLabelColor
			button.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
			self.stackView.addArrangedSubview(button)

			// The last segment is the one that identifies this row, so it reads as the primary content
			if index == (components.count - 1) {
				// Update color
				button.contentTintColor = .labelColor
			}

			// Add segment info
			self.segmentInfos.append(
					SegmentInfo(name: name, cumulativePath: cumulativePath, button: button,
							chevronTextField: chevronTextField))
		}

		// Measure each segment at its full width, once
		self.fullWidths =
				self.segmentInfos.map({
					// Set title
					$0.button.title = $0.name

					return $0.button.intrinsicContentSize.width
				})

		// Set accessibility label
		setAccessibilityLabel(self.segmentInfos.map({ $0.name }).joined(separator: ", "))

		// Needs layout
		self.needsLayout = true
	}

	//------------------------------------------------------------------------------------------------------------------
	private func updateCollapsedStates() {
		// Check if have anything to do
		guard !self.segmentInfos.isEmpty else { return }

		// Measure what a collapsed segment costs
		let	collapsedWidths :[CGFloat] =
					self.segmentInfos.map({
						// Get curent title
						let	title = $0.button.title

						// Set to ellipsis
						$0.button.title = "\u{2026}"

						// Measure
						let	width = $0.button.intrinsicContentSize.width

						// Restore title
						$0.button.title = title

						return width
					})

		// Decide which segments are shown in full.  The last is always full, as is anything hovered, and then segments
		//	are promoted from the tail toward the head while they still fit.
		var	isFull = [Bool](repeating: false, count: self.segmentInfos.count)
		if self.fullWidths.reduce(0.0, +) <= self.bounds.width {
			// Everything fits
			isFull = isFull.map({ _ in true })
		} else {
			// Not everything fits
			isFull[self.segmentInfos.count - 1] = true
			if let hoveredIndex = self.hoveredIndex { isFull[hoveredIndex] = true }

			var	usedWidth =
						(0 ..< self.segmentInfos.count)
								.reduce(0.0, { $0 + (isFull[$1] ? self.fullWidths[$1] : collapsedWidths[$1]) })

			for index in stride(from: self.segmentInfos.count - 2, through: 0, by: -1) {
				// Check if already full
				guard !isFull[index] else { continue }

				// Check if promoting fits
				let	deltaWidth = self.fullWidths[index] - collapsedWidths[index]
				if (usedWidth + deltaWidth) <= self.bounds.width {
					// Promote
					isFull[index] = true
					usedWidth += deltaWidth
				}
			}
		}

		// Apply
		self.segmentInfos.enumerated().forEach() {
			$0.element.button.title = isFull[$0.offset] ? $0.element.name : "\u{2026}"
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	private func updateHoveredIndex(_ hoveredIndex :Int?) {
		// Check if changed
		guard hoveredIndex != self.hoveredIndex else { return }

		// Update
		self.hoveredIndex = hoveredIndex

		// Needs layout
		self.needsLayout = true
	}
}
