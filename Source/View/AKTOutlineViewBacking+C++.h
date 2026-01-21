//----------------------------------------------------------------------------------------------------------------------
//	AKTOutlineViewBacking+C++.h			©2025 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "COutlineViewItem.h"
#import "CTableColumn.h"
#import "CTableViewBacking.h"
#import "SSortDescriptor.h"

#import <AppKit/AppKit.h>

#import "Swift.h"		// AKTOutlineViewBacking is defined in Swift so must include its interface somehow

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTOutlineViewBacking extension

typedef	void							(^AKTOutlineViewBackingSortDescriptorsDidChangeProc)(
												const TArray<SSortDescriptor>& sortDescriptors);
typedef	BOOL							(^AKTOutlineViewBackingCompareOutlineViewItemsProc)(
												const I<COutlineViewItem>& outlineViewItem1,
												const I<COutlineViewItem>& outlineViewItem2,
												const TArray<SSortDescriptor>& sortDescriptors);

typedef	TArray<I<COutlineViewItem> >	(^AKTOutlineViewBackingReloadChildOutlineViewItemsProc)(
												const I<COutlineViewItem>& outlineViewItem);

typedef	NSView* _Nullable				(^AKTOutlineViewBackingOutlineItemViewProc)(NSOutlineView* outlineView,
												NSTableColumn* tableColumn, NSInteger rowIndex,
												const I<COutlineViewItem>& outlineViewItem);

typedef	BOOL							(^AKTOutlineViewBackingShouldEditItemProc)(NSOutlineView* outlineView,
												NSTableColumn* tableColumn, const I<COutlineViewItem>& outlineViewItem);

@interface AKTOutlineViewBacking (Cpp)

// MARK: Properties

@property (nonatomic, readonly)	TArray<I<COutlineViewItem> >							selectedOutlineViewItems;
@property (nonatomic, readonly)	TArray<I<COutlineViewItem> >							topLevelOutlineViewItems;

@property (nonatomic, assign)	AKTOutlineViewBackingSortDescriptorsDidChangeProc		cppSortDescriptorsDidChangeProc;
@property (nonatomic, assign)	AKTOutlineViewBackingCompareOutlineViewItemsProc		compareOutlineViewItemsProc;

@property (nonatomic, assign)	AKTOutlineViewBackingReloadChildOutlineViewItemsProc	reloadChildOutlineViewItemsProc;

@property (nonatomic, assign)	AKTOutlineViewBackingOutlineItemViewProc				outlineViewItemViewProc;

@property (nonatomic, assign)	AKTOutlineViewBackingShouldEditItemProc					outlineViewBackingShouldEditItemProc;

// MARK: Instance methods

- (void) setCppSortDescriptors:(const TArray<SSortDescriptor>&) sortDescriptors;

- (void) setOutlineViewItems:(const TArray<I<COutlineViewItem> >&) outlineViewItems;
- (void) addOutlineViewItems:(const TArray<I<COutlineViewItem> >&) outlineViewItems;
- (void) removeOutlineViewItems:(const TArray<I<COutlineViewItem> >&) outlineViewItems;
- (I<COutlineViewItem>) outlineViewItemAtRow:(NSInteger) row;

- (void) reloadTableColumn:(const CTableColumn&) tableColumn;

- (void) reloadTableViewItem:(const CTableViewItem&) tableViewItem
		tableColumnIdentifiers:(const OV<TSet<CString> >&) tableColumnIdentifiers;

- (void) reloadOutlineViewItems:(TArray<I<COutlineViewItem> >&) outlineViewItems
		tableColumn:(const CTableColumn&) tableColumn;

@end

NS_ASSUME_NONNULL_END
