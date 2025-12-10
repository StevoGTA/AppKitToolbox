//----------------------------------------------------------------------------------------------------------------------
//	AKTOutlineViewHelper+C++.mm			©2025 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTOutlineViewHelper+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTOutlineViewHelper extension

@implementation AKTOutlineViewHelper (Cpp)

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (void) setOutlineViewBacking:(const COutlineViewBacking&) outlineViewBacking
		viewProc:
				(NSView* _Nullable(^)(NSOutlineView* outlineView, NSTableColumn* _Nullable tableColumn,
						const OV<I<COutlineViewItem> >& outlineViewItem)) viewProc
{
	// Setup
	self.hasChildrenProc =
			^BOOL(NSString* itemID){ return outlineViewBacking.hasChildren(CString((__bridge CFStringRef) itemID)); };
	self.childCountProc =
			^NSInteger(NSString* _Nullable itemID){
				// Return count
				return outlineViewBacking.getChildCount(
						(itemID != nil) ? OV<CString>(CString((__bridge CFStringRef) itemID)) : OV<CString>());
			};
	self.childItemIDProc =
			^NSString*(NSString* _Nullable itemID, NSInteger index){
				// Get item id
				CString	childItemID =
								outlineViewBacking.getChildItemID(
										(itemID != nil) ?
												OV<CString>(CString((__bridge CFStringRef) itemID)) :
												OV<CString>(),
										(UInt32) index);

				return (__bridge NSString*) childItemID.getOSString();
			};

	self.viewProc =
			^NSView*(NSOutlineView* outlineView, NSTableColumn* _Nullable tableColumn, NSString* _Nullable itemID){
				// Call proc
				return viewProc(outlineView, tableColumn,
						(itemID != nil) ?
								OV<I<COutlineViewItem> >(
										outlineViewBacking.getOutlineViewItem(CString((__bridge CFStringRef) itemID))) :
								OV<I<COutlineViewItem> >());
			};
}

@end
