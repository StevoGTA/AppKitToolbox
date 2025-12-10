//----------------------------------------------------------------------------------------------------------------------
//	AKTOutlineViewHelper+C++.h			©2025 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "COutlineViewBacking.h"

#import <AppKit/AppKit.h>
#import "Swift.h"		// AKTOutlineViewHelper is defined in Swift so must include its interface somehow

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTOutlineViewHelper extension

@interface AKTOutlineViewHelper (Cpp)

// MARK: Instance methods

- (void) setOutlineViewBacking:(const COutlineViewBacking&) outlineViewBacking
		viewProc:
				(NSView* _Nullable(^)(NSOutlineView* outlineView, NSTableColumn* _Nullable tableColumn,
						const OV<I<COutlineViewItem> >& outlineViewItem)) viewProc;

@end

NS_ASSUME_NONNULL_END
