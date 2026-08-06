//----------------------------------------------------------------------------------------------------------------------
//	AKTPathView.swift			©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTPathView
public class AKTPathView : NSView {

	// MARK: Style
	@objc(AKTPathViewStyle)
	public enum Style :Int {
		case standard
		case dimmed
	}

	// MARK: SegmentInfo
	private struct SegmentInfo {

		// MARK: Properties
		let	name :String

		let	button :NSButton
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
	@objc	public	var	style = Style.standard {
								didSet {
									// Check if changed
									guard self.style != oldValue else { return }

									// Update - only the tint changes, so nothing needs measuring again
									updateSegmentTints()
								}
							}
	@objc	public	var	font = NSFont.systemFont(ofSize: NSFont.systemFontSize) {
								didSet {
									// Check if changed
									guard self.font != oldValue else { return }

									// Update
									rebuildSegments()
								}
							}
	@objc	public	var	isEnabled = true {
								didSet {
									// Check if changed
									guard self.isEnabled != oldValue else { return }

									// Update
									rebuildSegments()
								}
							}
	@objc	public	var	folderDroppedProc :((_ url :URL) -> Void)? {
								didSet {
									// Only a path view that can do something with a folder should be a drag destination
									if self.folderDroppedProc != nil {
										// Accept folders
										self.layer?.cornerRadius = 4.0
										registerForDraggedTypes([.fileURL])
									} else {
										// Accept nothing
										unregisterDraggedTypes()
									}
								}
							}

			private	var	segmentInfos = [SegmentInfo]()
			private	var	fullWidths = [CGFloat]()
			private	var	collapsedWidths = [CGFloat]()
			private	var	fullContentWidth = CGFloat(0.0)
			private	var	hoveredIndex :Int?
			private	var	isDropTarget = false {
								didSet {
									// Check if changed
									guard self.isDropTarget != oldValue else { return }

									// Update
									let	color = NSColor.selectedContentBackgroundColor.withAlphaComponent(0.25)

									self.layer?.backgroundColor = self.isDropTarget ? color.cgColor : nil
								}
							}

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
		// A path view that is not taking clicks has nothing to say about where the mouse is
		guard self.isEnabled else { return }

		// Look for a segment under the mouse.  A chevron, or the space either side of it, is somewhere the mouse
		//	passes through on its way somewhere else - it is not someone deciding to stop reading - so passing
		//	over one leaves the hovered segment alone.  It gives way when the mouse reaches another segment, or
		//	leaves the path altogether.
		let	point = convert(event.locationInWindow, from: nil)
		guard let index =
				self.segmentInfos.firstIndex(
						where: { self.convert($0.button.bounds, from: $0.button).contains(point) })
				else { return }

		// Update hovered segment
		updateHoveredIndex(index)
	}

	//------------------------------------------------------------------------------------------------------------------
	public override func mouseExited(with event :NSEvent) { updateHoveredIndex(nil) }

	//------------------------------------------------------------------------------------------------------------------
	public override func draggingEntered(_ sender :NSDraggingInfo) -> NSDragOperation {
		// Check if have a folder to take
		guard folderURL(from: sender) != nil else { return [] }

		// Highlight
		self.isDropTarget = true

		return .copy
	}

	//------------------------------------------------------------------------------------------------------------------
	public override func draggingExited(_ sender :NSDraggingInfo?) { self.isDropTarget = false }

	//------------------------------------------------------------------------------------------------------------------
	public override func performDragOperation(_ sender :NSDraggingInfo) -> Bool {
		// Unhighlight
		self.isDropTarget = false

		// Check if have a folder to take
		guard let url = folderURL(from: sender) else { return false }

		// Call proc
		self.folderDroppedProc?(url)

		return true
	}

	//------------------------------------------------------------------------------------------------------------------
	public override func resetCursorRects() {
		// Do super
		super.resetCursorRects()

		// Check if taking clicks
		guard self.isEnabled else { return }

		// Every segment reveals something, so every segment gets the hand
		self.segmentInfos.forEach()
				{ addCursorRect(convert($0.button.bounds, from: $0.button), cursor: .pointingHand) }
	}

	//------------------------------------------------------------------------------------------------------------------
	public override func layout() {
		// Do super
		super.layout()

		// Decide which segments are shown in full
		updateCollapsedStates()

		// The segments may have moved out from under the cursor rects standing over them
		self.window?.invalidateCursorRects(for: self)
	}

	// MARK: Private methods
	//------------------------------------------------------------------------------------------------------------------
	private func setup() {
		// Setup self
		self.translatesAutoresizingMaskIntoConstraints = false
		self.wantsLayer = true
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
	private func folderURL(from draggingInfo :NSDraggingInfo) -> URL? {
		// A path view that is not taking clicks is not taking drops either
		guard self.isEnabled else { return nil }

		// Look for a lone file - anything else is not a destination
		let	urls =
					draggingInfo.draggingPasteboard.readObjects(forClasses: [NSURL.self],
							options: [.urlReadingFileURLsOnly: true]) as? [URL] ?? []
		guard urls.count == 1 else { return nil }

		// Ask the filesystem whether it is a folder - a URL only says whether it was written with a trailing
		//	separator, which says nothing about what is actually there
		let	isFolder = (try? urls[0].resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false

		return isFolder ? urls[0] : nil
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

		// Compose the segments to display
		let	components = self.path.split(separator: "/", omittingEmptySubsequences: true).map(String.init)
		let	rootComponents =
					(self.rootPath ?? "").split(separator: "/", omittingEmptySubsequences: true).map(String.init)
		let	skipCount = components.starts(with: rootComponents) ? rootComponents.count : 0
		let	isAbsolute = self.path.hasPrefix("/")

		// Separators are punctuation, not content, so they sit a step behind whatever the segments are showing.
		//	Every chevron is the same drawn glyph - a typed one is a third the height of a letter, far too
		//	slight to separate anything - so the image is composed here rather than once per separator.
		let	separatorColor :NSColor = self.isEnabled ? .tertiaryLabelColor : .quaternaryLabelColor
		let	chevronImage =
					NSImage(systemSymbolName: "chevron.right", accessibilityDescription: nil)?
									.withSymbolConfiguration(
											NSImage.SymbolConfiguration(pointSize: self.font.pointSize,
													weight: .semibold)) ??
							NSImage()

		// An absolute path shown from its start says so, the same way writing it out as a string does.  Shown from
		//	a root, it is being read relative to that root, so it says nothing.
		if isAbsolute && (skipCount == 0) && !components.isEmpty {
			// Leading separator.  A solidus runs the whole height of a line where the chevron beside it stands
			//	about as tall as a capital, so it is set smaller to keep the two reading as one family.
			let	textField = NSTextField(labelWithString: "/")
			textField.font = .systemFont(ofSize: self.font.pointSize * 0.85, weight: .semibold)
			textField.textColor = separatorColor

			self.stackView.addArrangedSubview(textField)
		}

		for index in skipCount ..< components.count {
			// Setup
			let	name = components[index]
			let	cumulativePath = (isAbsolute ? "/" : "") + components[0...index].joined(separator: "/")

			// Chevron, for all but the first displayed segment
			if index > skipCount {
				// Add chevron
				let	imageView = NSImageView(image: chevronImage)
				imageView.contentTintColor = separatorColor

				self.stackView.addArrangedSubview(imageView)
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
			button.font = self.font
			button.toolTip = cumulativePath
			button.isEnabled = self.isEnabled
			button.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
			self.stackView.addArrangedSubview(button)

			// Add segment info
			self.segmentInfos.append(SegmentInfo(name: name, button: button))
		}

		// Check if ending with a separator
		if self.showsTrailingSeparator && !self.segmentInfos.isEmpty {
			// Add trailing chevron
			let	imageView = NSImageView(image: chevronImage)
			imageView.contentTintColor = separatorColor

			self.stackView.addArrangedSubview(imageView)
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

		// Nothing is hovered, having just been built
		updateSegmentTints()

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

		// The chevrons and the spacing between everything are there whatever the titles say, so they are what
		//	every width below has to be measured on top of
		let	overheadWidth = self.fullContentWidth - self.fullWidths.reduce(0.0, +)

		// Decide which segments are shown in full, taking no account of what is hovered
		var	isFull :[Bool]
		if self.fullContentWidth <= self.bounds.width {
			// Everything fits
			isFull = [Bool](repeating: true, count: self.segmentInfos.count)
		} else {
			// Not everything fits, so the last is shown and the rest earn their place from the tail back
			isFull = [Bool](repeating: false, count: self.segmentInfos.count)
			isFull[self.segmentInfos.count - 1] = true
			show(&isFull, from: self.segmentInfos.count - 2, through: 0, overheadWidth: overheadWidth)
		}

		// Expand the hovered segment.  Its left edge must not move - if it did, it would slide out from under the
		//	mouse, the mouse would land on a different segment, and the path would flip back and forth - so
		//	everything after it is taken back and then earned again, leaving the room it needs to come only
		//	from there.
		if let hoveredIndex = self.hoveredIndex, !isFull[hoveredIndex] {
			// Expand
			isFull[hoveredIndex] = true
			for index in (hoveredIndex + 1) ..< self.segmentInfos.count {
				// Is not full
				isFull[index] = false
			}

			show(&isFull, from: self.segmentInfos.count - 1, through: hoveredIndex + 1, overheadWidth: overheadWidth)
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
	private func width(of isFull :[Bool], overheadWidth :CGFloat) -> CGFloat {
		// Add up what each segment is showing
		return (0 ..< self.segmentInfos.count)
				.reduce(overheadWidth,
						{ $0 + (isFull[$1] ? self.fullWidths[$1] : self.collapsedWidths[$1]) })
	}

	//------------------------------------------------------------------------------------------------------------------
	private func show(_ isFull :inout [Bool], from :Int, through :Int, overheadWidth :CGFloat) {
		// Setup
		var	usedWidth = width(of: isFull, overheadWidth: overheadWidth)

		// Show as many as will fit, working from the tail toward the head
		for index in stride(from: from, through: through, by: -1) {
			// Check if already showing
			guard !isFull[index] else { continue }

			// Check if showing this one fits
			let	deltaWidth = self.fullWidths[index] - self.collapsedWidths[index]
			guard (usedWidth + deltaWidth) <= self.bounds.width else { continue }

			// Show
			isFull[index] = true
			usedWidth += deltaWidth
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	private func updateSegmentTints() {
		// A path standing on its own is the value being shown, so it reads as one.  A path giving context to
		//	something else on the same line steps back so that something else reads first.
		let	color :NSColor = (self.style == .dimmed) ? .secondaryLabelColor : .labelColor

		// The segment under the mouse takes the accent color, which is what says it will act on a click
		self.segmentInfos.enumerated().forEach() {
			// Set tint
			$0.element.button.contentTintColor = ($0.offset == self.hoveredIndex) ? .controlAccentColor : color
		}
	}

	//------------------------------------------------------------------------------------------------------------------
	private func updateHoveredIndex(_ hoveredIndex :Int?) {
		// Check if changed
		guard hoveredIndex != self.hoveredIndex else { return }

		// Update
		self.hoveredIndex = hoveredIndex

		// Bring the hovered segment forward
		updateSegmentTints()

		// Expand and collapse by moving, not by jumping.  What is being read has just changed shape and position,
		//	and the eye can only follow that if it can see it happen.
		NSAnimationContext.runAnimationGroup({ context in
			// Setup
			context.duration = 0.3
			context.timingFunction = CAMediaTimingFunction(name: .easeOut)
			context.allowsImplicitAnimation = true

			// Update
			self.updateCollapsedStates()
			self.layoutSubtreeIfNeeded()
		})
	}
}
