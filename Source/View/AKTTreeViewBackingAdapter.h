//----------------------------------------------------------------------------------------------------------------------
//	AKTTreeViewBackingAdapter.h			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "AKTTreeViewBackingInterface.h"
#import "CTreeViewBacking.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTreeViewBackingAdapter

typedef	NSView*	_Nullable	(^AKTTreeViewBackingAdapterViewProc)(NSOutlineView* outlineView,
									NSTableColumn* _Nullable tableColumn, const CString& viewItemID,
									const I<CTreeItem>& treeItem);
typedef	void				(^AKTTreeViewBackingAdapterSelectionDidChangeProc)();

@interface AKTTreeViewBackingAdapter : NSObject <AKTTreeViewBackingInterface>

// MARK: Properties

@property (nonatomic, readonly)	TArray<I<CTreeItem> >							topLevelTreeItems;
@property (nonatomic, readonly)	TArray<I<CTreeItem> >							selectedTreeItems;

@property (nonatomic, strong)	AKTTreeViewBackingAdapterViewProc				viewProc;
@property (nonatomic, strong)	AKTTreeViewBackingAdapterSelectionDidChangeProc	selectionDidChangeProc;

// MARK: Lifecycle methods

- (instancetype) initWithOutlineView:(NSOutlineView*) outlineView
		treeViewBackingInfoGetChildTreeItemsProc:
				(CTreeViewBacking::Info::GetChildTreeItemsProc) treeViewBackingInfoGetChildTreeItemsProc;
- (instancetype) initWithOutlineView:(NSOutlineView*) outlineView
		treeViewBackingInfoLoadChildTreeItemsProc:
				(CTreeViewBacking::Info::LoadChildTreeItemsProc) treeViewBackingInfoLoadChildTreeItemsProc;

// MARK: Instance methods

- (void) setTopLevelTreeItems:(const TArray<I<CTreeItem> >&) topLevelTreeItems;
- (void) addTopLevelTreeItems:(const TArray<I<CTreeItem> >&) topLevelTreeItems;

- (void) reloadParentViewOfItemID:(const CString&) viewItemID reloadChildren:(BOOL) reloadChildren;

@end

NS_ASSUME_NONNULL_END
