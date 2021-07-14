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

@interface AKTTreeViewBackingAdapter : NSObject <AKTTreeViewBackingInterface>

// MARK: Properties

@property (nonatomic, strong)	AKTTreeViewBackingAdapterViewProc	viewProc;

// MARK: Lifecycle methods

- (instancetype) initWithOutlineView:(NSOutlineView*) outlineView;

// MARK: Instance methods

- (void) setTopLevelTreeItems:(const TArray<I<CTreeItem> >&) topLevelTreeItems;
- (void) addTopLevelTreeItems:(const TArray<I<CTreeItem> >&) topLevelTreeItems;

@end

NS_ASSUME_NONNULL_END
