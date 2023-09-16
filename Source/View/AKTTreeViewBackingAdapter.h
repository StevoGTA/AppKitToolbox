//----------------------------------------------------------------------------------------------------------------------
//	AKTTreeViewBackingAdapter.h			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "AKTTreeViewBackingInterface.h"
#import "CArray.h"
#import "CTreeItem.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTreeViewBackingAdapter

typedef	NSView*	_Nullable	(^AKTTreeViewBackingAdapterViewProc)(NSTableColumn* _Nullable tableColumn,
									const I<CTreeItem>& treeItem);
typedef	void				(^AKTTreeViewBackingAdapterSelectionDidChangeProc)();

@interface AKTTreeViewBackingAdapter : NSObject <AKTTreeViewBackingInterface>

// MARK: Properties

@property (nonatomic, readonly)	TArray<I<CTreeItem> >							topLevelTreeItems;
@property (nonatomic, readonly)	TArray<I<CTreeItem> >							selectedTreeItems;

@property (nonatomic, strong)	AKTTreeViewBackingAdapterViewProc				viewProc;
@property (nonatomic, strong)	AKTTreeViewBackingAdapterSelectionDidChangeProc	selectionDidChangeProc;

// MARK: Lifecycle methods

- (instancetype) initWithOutlineView:(NSOutlineView*) outlineView;

// MARK: Instance methods

- (void) setTopLevelTreeItems:(const TArray<I<CTreeItem> >&) topLevelTreeItems;
- (void) addTopLevelTreeItems:(const TArray<I<CTreeItem> >&) topLevelTreeItems;

@end

NS_ASSUME_NONNULL_END
