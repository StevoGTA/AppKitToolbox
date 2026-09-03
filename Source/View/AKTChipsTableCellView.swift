//----------------------------------------------------------------------------------------------------------------------
//	AKTChipsTableCellView.swift		©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

import AppKit

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTChipsTableCellView
public class AKTChipsTableCellView : NSTableCellView {

	// MARK: Properties
	override	public	var	backgroundStyle :NSView.BackgroundStyle {
									didSet { self.chipsView.isEmphasized = self.backgroundStyle == .emphasized }
								}

	@IBOutlet	public	var	chipsView :AKTChipsView!
}
