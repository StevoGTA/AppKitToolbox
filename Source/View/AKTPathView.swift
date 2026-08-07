//----------------------------------------------------------------------------------------------------------------------
//	AKTPathView.swift			©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTPathView
public class AKTPathView : NSView, NSViewToolTipOwner {

	// MARK: Style
	@objc(AKTPathViewStyle)
	public enum Style :Int {
		case standard
		case dimmed
	}

	// MARK: SegmentInfo
	private struct SegmentInfo {

		// MARK: Properties
		var	name :String
		var	cumulativePath :String

		let	button :NSButton
		let	leadingChevron :NSImageView?
	}

	// MARK: Properties
			static	private	let	segmentSpacing = CGFloat(2.0)

					// The four below depend only on the font they are keyed by - and, for text, on the string.  Paths
					//	in a list repeat their leading components over and over, so answering each of these once is most
					//	of the work of building a row.
			static	private	var	textWidths = [NSFont : [String : CGFloat]]()
			static	private	var	chevronImages = [NSFont : NSImage]()
			static	private	var	buttonInsetWidths = [NSFont : CGFloat]()
			static	private	var	buttonHeights = [NSFont : CGFloat]()

	@objc			public	var	rootPath :String? {
										didSet {
											// Check if changed
											guard self.rootPath != oldValue else { return }

											// Update
											reconcile()
										}
									}
	@objc			public	var	path :String = "" {
										didSet {
											// Check if changed
											guard self.path != oldValue else { return }

											// Update
											reconcile()
										}
									}
	@objc			public	var	showsTrailingSeparator = false {
										didSet {
											// Check if changed
											guard self.showsTrailingSeparator != oldValue else { return }

											// Update
											reconcile()
										}
									}
	@objc			public	var	style = Style.standard {
										didSet {
											// Check if changed
											guard self.style != oldValue else { return }

											// Update - only the tint changes, so nothing needs measuring again
											updateSegmentTints()
										}
									}
	@objc			public	var	font = NSFont.systemFont(ofSize: NSFont.systemFontSize) {
										didSet {
											// Check if changed
											guard self.font != oldValue else { return }

											// Update
											rebuild()
										}
									}
	@objc			public	var	isEnabled = true {
										didSet {
											// Check if changed
											guard self.isEnabled != oldValue else { return }

											// Update
											rebuild()
										}
									}
	@objc			public	var	folderDroppedProc :((_ url :URL) -> Void)? {
										didSet {
											// Only a path view that can do something with a folder should be a drag
											//	destination
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
					private	var	rootTextField :NSTextField?
					private	var	trailingChevron :NSImageView?

					private	var	fullWidths = [CGFloat]()
					private	var	collapsedWidth = CGFloat(0.0)
					private	var	overheadWidth = CGFloat(0.0)
					private	var	fullContentWidth = CGFloat(0.0)
					private	var	contentHeight = CGFloat(0.0)
					private	var	buttonHeight = CGFloat(0.0)
					private	var	chevronSize = NSSize.zero
					private	var	rootSize = NSSize.zero

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
		return NSSize(width: self.fullContentWidth, height: self.contentHeight)
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

		// Replace tool tip rect.  One rect for the whole path, resolved to a segment only when the tool tip is
		//	actually asked for - a rect per segment means a list of these hands the window hundreds of them
		//	to keep track of.
		removeAllToolTips()
		_ = addToolTip(self.bounds, owner: self, userData: nil)
	}

	//------------------------------------------------------------------------------------------------------------------
	public override func mouseMoved(with event :NSEvent) {
		// A path view that is not taking clicks has nothing to say about where the mouse is
		guard self.isEnabled else { return }

		// Look for a segment under the mouse.  A chevron, or the space either side of it, is somewhere the mouse
		//	passes through on its way somewhere else - it is not someone deciding to stop reading - so passing
		//	over one leaves the hovered segment alone.  It gives way when the mouse reaches another segment, or
		//	leaves the path altogether.
		guard let index = segmentIndex(at: convert(event.locationInWindow, from: nil)) else { return }

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
		self.segmentInfos.forEach() { addCursorRect($0.button.frame, cursor: .pointingHand) }
	}

	//------------------------------------------------------------------------------------------------------------------
	public func view(_ view :NSView, stringForToolTip tag :NSView.ToolTipTag, point :NSPoint,
			userData data :UnsafeMutableRawPointer?) -> String {
		// Say where a click here would land
		guard let index = segmentIndex(at: point) else { return "" }

		return self.segmentInfos[index].cumulativePath
	}

	//------------------------------------------------------------------------------------------------------------------
	public override func layout() {
		// Do super
		super.layout()

		// Decide what is shown in full, and put everything where that leaves it
		apply(collapsedStates())
	}

	// MARK: Private methods
	//------------------------------------------------------------------------------------------------------------------
	private func setup() {
		// Setup self.  The segments are placed by hand rather than by constraints - a list lays these out again
		//	for every row it recycles, and a constraint graph that has to be torn down and solved each time is
		//	most of what that costs.
		self.translatesAutoresizingMaskIntoConstraints = false
		self.wantsLayer = true
		setAccessibilityRole(.group)

		// The path hugs its content, and gives way before anything beside it does
		setContentHuggingPriority(.defaultHigh, for: .horizontal)
		setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
	}

	//------------------------------------------------------------------------------------------------------------------
	private class func textWidth(_ string :String, font :NSFont) -> CGFloat {
		// Check if already known
		if let width = AKTPathView.textWidths[font]?[string] { return width }

		// Measure, and remember
		let	width = (string as NSString).size(withAttributes: [.font: font]).width
		AKTPathView.textWidths[font, default: [:]][string] = width

		return width
	}

	//------------------------------------------------------------------------------------------------------------------
	private func segmentIndex(at point :NSPoint) -> Int? {
		// Every segment is placed in this view's own coordinates
		return self.segmentInfos.firstIndex(where: { $0.button.frame.contains(point) })
	}

	//------------------------------------------------------------------------------------------------------------------
	private func folderURL(from draggingInfo :NSDraggingInfo) -> URL? {
		// A path view that is not taking clicks is not taking drops either
		guard self.isEnabled else { return nil }

		// Look for a lone item - anything else is not a destination
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
	private func chevronImageView(_ color :NSColor) -> NSImageView {
		// Setup
		let	imageView = NSImageView(image: AKTPathView.chevronImages[self.font] ?? NSImage())
		imageView.translatesAutoresizingMaskIntoConstraints = true
		imageView.contentTintColor = color
		addSubview(imageView)

		return imageView
	}

	//------------------------------------------------------------------------------------------------------------------
	private func rebuild() {
		// Throw everything away, so that what comes back is built to the font and state now in force
		self.subviews.forEach({ $0.removeFromSuperview() })
		self.segmentInfos = []
		self.rootTextField = nil
		self.trailingChevron = nil

		reconcile()
	}

	//------------------------------------------------------------------------------------------------------------------
	private func reconcile() {
		// Compose the segments to display
		let	components = self.path.split(separator: "/", omittingEmptySubsequences: true).map(String.init)
		let	rootComponents =
				(self.rootPath ?? "").split(separator: "/", omittingEmptySubsequences: true).map(String.init)
		let	skipCount = components.starts(with: rootComponents) ? rootComponents.count : 0
		let	isAbsolute = self.path.hasPrefix("/")

		// Separators are punctuation, not content, so they sit a step behind whatever the segments are showing.
		//	Every chevron is the same drawn glyph - a typed one is a third the height of a letter, far too
		//	slight to separate anything - and it answers only to the font, so it is drawn once per font.
		let	separatorColor :NSColor = self.isEnabled ? .tertiaryLabelColor : .quaternaryLabelColor
		if AKTPathView.chevronImages[self.font] == nil {
			// Draw for this font
			AKTPathView.chevronImages[self.font] =
					NSImage(systemSymbolName: "chevron.right", accessibilityDescription: nil)?
									.withSymbolConfiguration(
											NSImage.SymbolConfiguration(pointSize: self.font.pointSize,
													weight: .semibold)) ??
							NSImage()
		}

		self.chevronSize = (AKTPathView.chevronImages[self.font] ?? NSImage()).size

		// An absolute path shown from its start says so, the same way writing it out as a string does.  Shown
		//	from a root, it is being read relative to that root, so it says nothing.
		let	wantsRoot = isAbsolute && (skipCount == 0) && !components.isEmpty
		if wantsRoot && (self.rootTextField == nil) {
			// Leading separator.  A solidus runs the whole height of a line where the chevron beside it stands
			//	about as tall as a capital, so it is set smaller to keep the two reading as one family.
			let	textField = NSTextField(labelWithString: "/")
			textField.translatesAutoresizingMaskIntoConstraints = true
			textField.font = .systemFont(ofSize: self.font.pointSize * 0.85, weight: .semibold)
			textField.textColor = separatorColor
			addSubview(textField)

			self.rootTextField = textField
		} else if !wantsRoot, let textField = self.rootTextField {
			// No longer wanted
			textField.removeFromSuperview()
			self.rootTextField = nil
		}

		// Measure it now, while the segments and their widths are still the consistent pair they were - asking a
		//	view for its size can lay out then and there, which lands back in layout().  There is at most one
		//	of these, so it is measured rather than remembered.
		self.rootSize = self.rootTextField?.fittingSize ?? .zero

		// Keep as many segments as are needed, reusing whatever is already here.  A list hands this the same
		//	shape of path over and over, so building the views again for each row is the bulk of what a row
		//	costs - where handing an existing one a different name costs almost nothing.
		let	neededCount = components.count - skipCount
		while self.segmentInfos.count > neededCount {
			// Take away the last
			let	segmentInfo = self.segmentInfos.removeLast()
			segmentInfo.button.removeFromSuperview()
			segmentInfo.leadingChevron?.removeFromSuperview()
		}
		while self.segmentInfos.count < neededCount {
			// Add one more.  Which path a segment reveals is looked up when it is clicked, so the same button can
			//	be handed a different segment without ever needing a new action.
			let	index = self.segmentInfos.count
			let	button =
						NSButton(title: "",
								actionProc: { [weak self] control in
									// Reveal in the Finder
									guard let cumulativePath = self?.segmentInfos[control.tag].cumulativePath
											else { return }

									NSWorkspace.shared.activateFileViewerSelecting(
											[URL(fileURLWithPath: cumulativePath)])
								})
			button.translatesAutoresizingMaskIntoConstraints = true
			button.tag = index
			button.isBordered = false
			button.bezelStyle = .inline
			button.font = self.font
			button.isEnabled = self.isEnabled
			addSubview(button)

			self.segmentInfos.append(
					SegmentInfo(name: "", cumulativePath: "", button: button,
							leadingChevron: (index > 0) ? chevronImageView(separatorColor) : nil))
		}

		// Say what each one is now showing
		for index in 0 ..< neededCount {
			// Update
			let	name = components[skipCount + index]

			self.segmentInfos[index].name = name
			self.segmentInfos[index].cumulativePath =
					(isAbsolute ? "/" : "") + components[0 ... (skipCount + index)].joined(separator: "/")
			self.segmentInfos[index].button.title = name
		}

		// Check if ending with a separator
		let	wantsTrailing = self.showsTrailingSeparator && !self.segmentInfos.isEmpty
		if wantsTrailing && (self.trailingChevron == nil) {
			// Add trailing chevron
			self.trailingChevron = chevronImageView(separatorColor)
		} else if !wantsTrailing, let imageView = self.trailingChevron {
			// No longer wanted
			imageView.removeFromSuperview()
			self.trailingChevron = nil
		}

		// Measure.  Text is measured on its own rather than by asking a view for its intrinsic size, because
		//	that lays the view out.  A button is its title plus a fixed inset, which answers only to the font,
		//	so it is taken from a real one the first time a font is seen and remembered after that.
		if AKTPathView.buttonInsetWidths[self.font] == nil, let segmentInfo = self.segmentInfos.first {
			// Take what a button makes of a title it already has
			let	size = segmentInfo.button.intrinsicContentSize

			AKTPathView.buttonInsetWidths[self.font] =
					size.width - AKTPathView.textWidth(segmentInfo.name, font: self.font)
			AKTPathView.buttonHeights[self.font] = size.height
		}

		let	buttonInsetWidth = AKTPathView.buttonInsetWidths[self.font] ?? 0.0
		self.buttonHeight = AKTPathView.buttonHeights[self.font] ?? 0.0

		// Every width below is rounded up to a whole point.  They are added up from text measurements, which are
		//	fractional, while the width this view is handed is snapped to the screen - so asking for 548.3 and
		//	being given 548.0 would read as not fitting, and a whole segment would be dropped to recover three
		//	tenths of a point.
		self.fullWidths =
				self.segmentInfos.map(
						{ (AKTPathView.textWidth($0.name, font: self.font) + buttonInsetWidth).rounded(.up) })
		self.collapsedWidth = (AKTPathView.textWidth("\u{2026}", font: self.font) + buttonInsetWidth).rounded(.up)

		let	chevronCount = max(self.segmentInfos.count - 1, 0) + ((self.trailingChevron != nil) ? 1 : 0)
		let	elementCount = self.segmentInfos.count + chevronCount + ((self.rootTextField != nil) ? 1 : 0)
		self.overheadWidth =
				(self.rootSize.width + self.chevronSize.width * CGFloat(chevronCount) +
						AKTPathView.segmentSpacing * CGFloat(max(elementCount - 1, 0))).rounded(.up)
		self.fullContentWidth = self.overheadWidth + self.fullWidths.reduce(0.0, +)
		self.contentHeight =
				self.segmentInfos.isEmpty ?
						0.0 :
						max(self.buttonHeight, (chevronCount > 0) ? self.chevronSize.height : 0.0, self.rootSize.height)

		// Nothing is hovered, the path having just changed
		self.hoveredIndex = nil
		updateSegmentTints()

		invalidateIntrinsicContentSize()

		// Set accessibility label
		setAccessibilityLabel(self.segmentInfos.map({ $0.name }).joined(separator: ", "))

		// Needs layout, and the cursor rects standing over the segments no longer stand over the same ones
		self.window?.invalidateCursorRects(for: self)
		self.needsLayout = true
	}

	//------------------------------------------------------------------------------------------------------------------
	private func collapsedStates() -> [Bool] {
		// Check if have anything to do
		guard !self.segmentInfos.isEmpty else { return [] }

		// Check the widths are in step with the segments.  Measuring a view can lay out synchronously, which
		//	lands back here part-way through rebuilding these two - so this pass is skipped, and the one
		//	asked for at the end of that rebuild does the work.
		guard self.fullWidths.count == self.segmentInfos.count else { return [] }

		// Decide which segments are shown in full, taking no account of what is hovered
		var	isFull :[Bool]
		if self.fullContentWidth <= self.bounds.width {
			// Everything fits
			isFull = [Bool](repeating: true, count: self.segmentInfos.count)
		} else {
			// Not everything fits, so the last is shown and the rest earn their place from the tail back
			isFull = [Bool](repeating: false, count: self.segmentInfos.count)
			isFull[self.segmentInfos.count - 1] = true
			show(&isFull, from: self.segmentInfos.count - 2, through: 0)
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

			show(&isFull, from: self.segmentInfos.count - 1, through: hoveredIndex + 1)
		}

		return isFull
	}

	//------------------------------------------------------------------------------------------------------------------
	private func apply(_ isFull :[Bool]) {
		// Check if have anything to place
		guard !isFull.isEmpty else { return }

		// Place everything, left to right
		var	x = CGFloat(0.0)
		var	didChangeTitle = false

		if let textField = self.rootTextField { place(textField, at: &x, size: self.rootSize) }

		for (index, segmentInfo) in self.segmentInfos.enumerated() {
			// Separator
			if let imageView = segmentInfo.leadingChevron { place(imageView, at: &x, size: self.chevronSize) }

			// Check if what it is showing has changed
			let	title = isFull[index] ? segmentInfo.name : "\u{2026}"
			if segmentInfo.button.title != title {
				// Update title
				segmentInfo.button.title = title
				didChangeTitle = true
			}

			// Segment
			place(segmentInfo.button, at: &x,
					size: NSSize(width: isFull[index] ? self.fullWidths[index] : self.collapsedWidth,
							height: self.buttonHeight))
		}

		if let imageView = self.trailingChevron { place(imageView, at: &x, size: self.chevronSize) }

		// Check if anything moved.  Only then are the cursor rects standing over the segments stale - asking for
		//	them on every layout has the window rebuilding them for every row of a list that is merely
		//	scrolling.
		if didChangeTitle { self.window?.invalidateCursorRects(for: self) }
	}

	//------------------------------------------------------------------------------------------------------------------
	private func place(_ view :NSView, at x :inout CGFloat, size :NSSize) {
		// Center in what height there is, and take no more width than is left
		let	frame =
					NSRect(x: x, y: ((self.bounds.height - size.height) / 2.0).rounded(),
							width: max(min(size.width, self.bounds.width - x), 0.0), height: max(size.height, 0.0))

		// Move, animating only when that is what is being asked for
		if NSAnimationContext.current.allowsImplicitAnimation {
			// Animate
			view.animator().frame = frame
		} else {
			// Move
			view.frame = frame
		}

		// Advance
		x += size.width + AKTPathView.segmentSpacing
	}

	//------------------------------------------------------------------------------------------------------------------
	private func show(_ isFull :inout [Bool], from :Int, through :Int) {
		// Setup - what is on show already, on top of what is there whatever the segments show
		var	usedWidth =
				(0 ..< self.segmentInfos.count)
						.reduce(self.overheadWidth,
								{ $0 + (isFull[$1] ? self.fullWidths[$1] : self.collapsedWidth) })

		// Show as many as will fit, working from the tail toward the head
		for index in stride(from: from, through: through, by: -1) {
			// Check if already showing
			guard !isFull[index] else { continue }

			// Check if showing this one fits
			let	deltaWidth = self.fullWidths[index] - self.collapsedWidth
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
			self.needsLayout = true
			self.layoutSubtreeIfNeeded()
		})
	}
}
