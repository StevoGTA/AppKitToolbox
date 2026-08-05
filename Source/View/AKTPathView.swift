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
	@objc	public	var	showsTrailingSeparator = false {
								didSet {
									// Check if changed
									guard self.showsTrailingSeparator != oldValue else { return }

									// Update
									rebuildSegments()
								}
							}

			private	var	segmentInfos = [SegmentInfo]()
			private	var	fullWidths = [CGFloat]()
			private	var	collapsedWidths = [CGFloat]()
			private	var	fullContentWidth = CGFloat(0.0)
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
	public override var intrinsicContentSize :NSSize {
		NSSize(width: self.fullContentWidth, height: NSView.noIntrinsicMetric)
	}

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

		// The path hugs its content, and gives way before anything beside it does
		setContentHuggingPriority(.defaultHigh, for: .horizontal)
		setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
	}

	//------------------------------------------------------------------------------------------------------------------
	private class func chevronTextField() -> NSTextField {
		// Setup
		let	textField = NSTextField(labelWithString: "\u{203A}")
		textField.font = .boldSystemFont(ofSize: NSFont.systemFontSize)
		textField.textColor = .secondaryLabelColor

		return textField
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
		self.collapsedWidths = []
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
				let	textField = AKTPathView.chevronTextField()
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

			// Add segment info
			self.segmentInfos.append(
					SegmentInfo(name: name, cumulativePath: cumulativePath, button: button,
							chevronTextField: chevronTextField))
		}

		// Check if ending with a separator
		if self.showsTrailingSeparator && !self.segmentInfos.isEmpty {
			// Add trailing chevron
			self.stackView.addArrangedSubview(AKTPathView.chevronTextField())
		}

		// Measure each segment, full and collapsed, before anything below can trigger laying out - reading fittingSize
		//	or invalidating the intrinsic size can lay out synchronously, and that would run against half-filled caches
		self.fullWidths =
				self.segmentInfos.map({
					// Set title
					$0.button.title = $0.name

					return $0.button.intrinsicContentSize.width
				})
		self.collapsedWidths =
				self.segmentInfos.map({
					// Set title
					$0.button.title = "\u{2026}"

					return $0.button.intrinsicContentSize.width
				})
		self.segmentInfos.forEach({ $0.button.title = $0.name })

		// Note the width everything needs, while the titles are full
		self.fullContentWidth = self.stackView.fittingSize.width
		invalidateIntrinsicContentSize()

		// Set accessibility label
		setAccessibilityLabel(self.segmentInfos.map({ $0.name }).joined(separator: ", "))

		// Needs layout
		self.needsLayout = true
	}

	//------------------------------------------------------------------------------------------------------------------
	private func updateCollapsedStates() {
		// Check if have anything to do
		guard !self.segmentInfos.isEmpty else { return }

		// Check the measurements are in step with the segments
		guard (self.fullWidths.count == self.segmentInfos.count) &&
				(self.collapsedWidths.count == self.segmentInfos.count) else { return }

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
								.reduce(0.0, { $0 + (isFull[$1] ? self.fullWidths[$1] : self.collapsedWidths[$1]) })

			for index in stride(from: self.segmentInfos.count - 2, through: 0, by: -1) {
				// Check if already full
				guard !isFull[index] else { continue }

				// Check if promoting fits
				let	deltaWidth = self.fullWidths[index] - self.collapsedWidths[index]
				if (usedWidth + deltaWidth) <= self.bounds.width {
					// Promote
					isFull[index] = true
					usedWidth += deltaWidth
				}
			}
		}

		// Apply
		self.segmentInfos.enumerated().forEach() {
			// Setup
			let	title = isFull[$0.offset] ? $0.element.name : "\u{2026}"

			// Check if changed - setting a title invalidates the layout this is running within, so setting it to
			//	what it already is would keep laying out forever
			if $0.element.button.title != title {
				// Update title
				$0.element.button.title = title
			}
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
