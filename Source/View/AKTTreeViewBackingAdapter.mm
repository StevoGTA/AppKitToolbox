//----------------------------------------------------------------------------------------------------------------------
//	AKTTreeViewBackingAdapter.mm			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTTreeViewBackingAdapter.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTreeViewBackingAdapter

@interface AKTTreeViewBackingAdapter () <NSOutlineViewDataSource, NSOutlineViewDelegate>

// MARK: Properties

@property (nonatomic, weak)		NSOutlineView*		outlineView;

@property (nonatomic, assign)	CTreeViewBacking*	treeViewBacking;

@end

@implementation AKTTreeViewBackingAdapter

// MARK: Property methods

//----------------------------------------------------------------------------------------------------------------------
- (TArray<I<CTreeItem> >) topLevelTreeItems
//----------------------------------------------------------------------------------------------------------------------
{
	return self.treeViewBacking->getTopLevelTreeItems();
}

//----------------------------------------------------------------------------------------------------------------------
- (TArray<I<CTreeItem> >) selectedTreeItems
//----------------------------------------------------------------------------------------------------------------------
{
	// Collect view item IDs
	__block	TNArray<CString>	viewItemIDs;
	[self.outlineView.selectedRowIndexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL* stop) {
		// Add view item ID
		viewItemIDs += CString((__bridge CFStringRef) [self.outlineView itemAtRow:index]);
	}];

	return self.treeViewBacking->getTreeItems(viewItemIDs);
}

// MARK: Lifecycle methods

//----------------------------------------------------------------------------------------------------------------------
- (instancetype) initWithOutlineView:(NSOutlineView*) outlineView
		treeViewBackingInfoGetChildTreeItemsProc:
				(CTreeViewBacking::Info::GetChildTreeItemsProc) treeViewBackingInfoGetChildTreeItemsProc
{
	self = [super init];
	if (self != nil) {
		// Store
		self.outlineView = outlineView;

		// Setup
		self.treeViewBacking =
				new CTreeViewBacking(
						CTreeViewBacking::Info(treeViewBackingInfoGetChildTreeItemsProc, nil, nil,
								(__bridge void*) self));

		// Setup NSOutlineView
		self.outlineView.dataSource = self;
		self.outlineView.delegate = self;
	}

	return self;
}

//----------------------------------------------------------------------------------------------------------------------
- (instancetype) initWithOutlineView:(NSOutlineView*) outlineView
		treeViewBackingInfoLoadChildTreeItemsProc:
				(CTreeViewBacking::Info::LoadChildTreeItemsProc) treeViewBackingInfoLoadChildTreeItemsProc
{
	self = [super init];
	if (self != nil) {
		// Store
		self.outlineView = outlineView;

		// Setup
		self.treeViewBacking =
				new CTreeViewBacking(
						CTreeViewBacking::Info(nil, treeViewBackingInfoLoadChildTreeItemsProc, nil,
								(__bridge void*) self));

		// Setup NSOutlineView
		self.outlineView.dataSource = self;
		self.outlineView.delegate = self;
	}

	return self;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) dealloc
{
	// Cleanup
	Delete(self.treeViewBacking);
}

// MARK: AKTTreeViewBackingInterface methods

// MARK: NSOutlineViewDataSource methods

//----------------------------------------------------------------------------------------------------------------------
- (NSInteger) outlineView:(NSOutlineView*) outlineView numberOfChildrenOfItem:(id) item
{
	// Return child count
	return self.treeViewBacking->getChildCount([self viewItemIDForItem:item]);
}

//----------------------------------------------------------------------------------------------------------------------
- (id) outlineView:(NSOutlineView*) outlineView child:(NSInteger) index ofItem:(id) item
{
	// Return child view item ID
	return [self
			itemForViewItemID:self.treeViewBacking->getChildViewItemID([self viewItemIDForItem:item], (UInt32) index)];
}

////----------------------------------------------------------------------------------------------------------------------
- (BOOL) outlineView:(NSOutlineView*) outlineView isItemExpandable:(id) item
{
	return self.treeViewBacking->getTreeItem([self viewItemIDForItem:item])->hasChildren();
}

// MARK: NSOutlineViewDelegate methods

//----------------------------------------------------------------------------------------------------------------------
- (NSView*) outlineView:(NSOutlineView*) outlineView viewForTableColumn:(NSTableColumn*) tableColumn item:(id) item
{
	// Setup
	CString	viewItemID = [self viewItemIDForItem:item];

	return self.viewProc(self.outlineView, tableColumn, viewItemID, self.treeViewBacking->getTreeItem(viewItemID));
}

//----------------------------------------------------------------------------------------------------------------------
- (void) outlineViewSelectionDidChange:(NSNotification*) notification
{
	// Call proc
}

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (void) setTopLevelTreeItems:(const TArray<I<CTreeItem> >&) topLevelTreeItems
{
	// Set top level tree items
	self.treeViewBacking->set(topLevelTreeItems);
}

//----------------------------------------------------------------------------------------------------------------------
- (void) addTopLevelTreeItems:(const TArray<I<CTreeItem> >&) topLevelTreeItems
{
	// Update Tree View Backing
	self.treeViewBacking->add(topLevelTreeItems);

	// Update UI
	[self.outlineView reloadData];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) reloadParentViewOfItemID:(const CString&) viewItemID reloadChildren:(BOOL) reloadChildren
{
	// Reload parent of given view item ID
	[self.outlineView reloadItem:[self.outlineView parentForItem:[self itemForViewItemID:viewItemID]]
			reloadChildren:reloadChildren];
}

// MARK: Private methods

//----------------------------------------------------------------------------------------------------------------------
- (CString) viewItemIDForItem:(nullable id) item
{
	// Return view item ID
	return (item == nil) ? CTreeViewBacking::mRootViewItemID : CString((__bridge CFStringRef) item);
}

//----------------------------------------------------------------------------------------------------------------------
- (id) itemForViewItemID:(const CString&) viewItemID
{
	return (__bridge NSString*) viewItemID.getOSString();
}

@end
