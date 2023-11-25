//----------------------------------------------------------------------------------------------------------------------
//	AKTTreeViewBackingAdapter.mm			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTTreeViewBackingAdapter.h"

#import "CTreeViewBacking.h"
#import "NSString+C++.h"

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
{
	self = [super init];
	if (self != nil) {
		// Store
		self.outlineView = outlineView;

		// Setup
		self.treeViewBacking = new CTreeViewBacking(CTreeViewBacking::Info(nil, nil, nil, nil, (__bridge void*) self));

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
return item == nil;
}

////----------------------------------------------------------------------------------------------------------------------
//- (id) outlineView:(NSOutlineView*) outlineView objectValueForTableColumn:(NSTableColumn*) tableColumn byItem:(id) item
//{
//return @"ABC";
//}

////----------------------------------------------------------------------------------------------------------------------
//- (void) outlineView:(NSOutlineView*) outlineView sortDescriptorsDidChange:(NSArray<NSSortDescriptor*>*) oldDescriptors
//{
//}

// MARK: NSOutlineViewDelegate methods

//----------------------------------------------------------------------------------------------------------------------
- (NSView*) outlineView:(NSOutlineView*) outlineView viewForTableColumn:(NSTableColumn*) tableColumn item:(id) item
{
	return self.viewProc(tableColumn, self.treeViewBacking->getTreeItem([self viewItemIDForItem:item]));
}

////----------------------------------------------------------------------------------------------------------------------
//- (void) outlineViewItemDidExpand:(NSNotification*) notification
//{
//}

////----------------------------------------------------------------------------------------------------------------------
//- (void) outlineViewItemDidCollapse:(NSNotification*) notification
//{
//}

////----------------------------------------------------------------------------------------------------------------------
//- (BOOL) outlineView:(NSOutlineView*) outlineView shouldSelectItem:(id) item
//{
//return NO;
//}

//----------------------------------------------------------------------------------------------------------------------
- (void) outlineViewSelectionDidChange:(NSNotification*) notification
{
	// Call proc
	self.selectionDidChangeProc();
}

////----------------------------------------------------------------------------------------------------------------------
//- (BOOL) outlineView:(NSOutlineView*) outlineView isGroupItem:(id) item
//{
//return NO;
//}

////----------------------------------------------------------------------------------------------------------------------
//- (CGFloat) outlineView:(NSOutlineView*) outlineView sizeToFitWidthOfColumn:(NSInteger) column
//{
//return 0.0;
//}

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
	return [((__bridge NSString*) viewItemID.getOSString()) copy];
}

@end

/*
	// MARK: NSOutlineViewDataSource methods
	//------------------------------------------------------------------------------------------------------------------
    public func outlineView(_ outlineView :NSOutlineView, numberOfChildrenOfItem outlineViewItem :Any?) -> Int {
		// Return child count
		return self.treeViewBackingStore?.numberOfChildren(for: outlineViewItem as? LightIronTreeViewItem) ?? 0
	}

	//------------------------------------------------------------------------------------------------------------------
    public func outlineView(_ outlineView :NSOutlineView, child index :Int, ofItem outlineViewItem :Any?) -> Any {
		// Return child item
		return self.treeViewBackingStore!.child(of: outlineViewItem as? LightIronTreeViewItem, at: index)
	}

	//------------------------------------------------------------------------------------------------------------------
    public func outlineView(_ outlineView :NSOutlineView, isItemExpandable outlineViewItem :Any) -> Bool {
		// Return if item has children
		return self.treeViewBackingStore!.numberOfChildren(for: (outlineViewItem as! LightIronTreeViewItem)) > 0
	}

	//------------------------------------------------------------------------------------------------------------------
	public func outlineView(_ outlineView :NSOutlineView, objectValueFor tableColumn :NSTableColumn?,
			byItem outlineViewItem :Any?) -> Any? {
		// Return tree item
		return self.treeViewBackingStore!.treeItem(for: (outlineViewItem as! LightIronTreeViewItem))
	}

	//------------------------------------------------------------------------------------------------------------------
    public func outlineView(_ outlineView :NSOutlineView, sortDescriptorsDidChange oldDescriptors :[NSSortDescriptor]) {
		// Update sort
		if let compareInfo = self.sortDescriptorsDidChangeProc?(self.sortDescriptors) {
			// Update sorting
			self.treeViewBackingStore?.updateSorting(compareInfo: compareInfo)

			// Reload data
			reloadDataRetainingSelection()
		}
	}

	// MARK: NSOutlineViewDelegate methods
	//------------------------------------------------------------------------------------------------------------------
    public func outlineView(_ outlineView :NSOutlineView, viewFor tableColumn :NSTableColumn?,
    		item outlineViewItem :Any) -> NSView? {
		// Setup
		let	treeViewItem = outlineViewItem as! LightIronTreeViewItem

    	// Call proc
		return self.viewForProc(tableColumn, treeViewItem, self.treeViewBackingStore!.treeItem(for: treeViewItem),
				self.treeViewBackingStore!.isCurrentlyLoading(for: treeViewItem))
	}

	//------------------------------------------------------------------------------------------------------------------
	public func outlineViewItemDidExpand(_ notification :Notification) {
		// Call proc
		self.treeItemDidExpandProc(treeItem(for: notification.userInfo!["NSObject"] as! LightIronTreeViewItem))
	}

	//------------------------------------------------------------------------------------------------------------------
	public func outlineViewItemDidCollapse(_ notification :Notification) {
		// Notify
		self.treeViewBackingStore!.didCollapse(
				treeViewItem: notification.userInfo!["NSObject"] as! LightIronTreeViewItem)

		// Call proc
		self.treeItemDidCollapseProc(treeItem(for: notification.userInfo!["NSObject"] as! LightIronTreeViewItem))
	}

	//------------------------------------------------------------------------------------------------------------------
	public func outlineView(_ outlineView :NSOutlineView, shouldSelectItem item :Any) -> Bool {
		// Return should select item
		return self.isGroupItemProc(self.treeItem(for: item as! LightIronTreeViewItem)) ?
				self.options.contains(.canSelectGroupItems) : true
	}

	//------------------------------------------------------------------------------------------------------------------
	public func outlineViewSelectionDidChange(_ notification :Notification) {
		// Call proc
		self.selectionDidChangeProc(self.treeItems(for: self.selectedItems as! [LightIronTreeViewItem]))
	}

	//------------------------------------------------------------------------------------------------------------------
	public func outlineView(_ outlineView :NSOutlineView, isGroupItem item :Any) -> Bool {
		// Call proc
		return self.isGroupItemProc(self.treeItem(for: item as! LightIronTreeViewItem))
	}

	//------------------------------------------------------------------------------------------------------------------
	public func outlineView(_ outlineView :NSOutlineView, sizeToFitWidthOfColumn column :Int) -> CGFloat {
		// Call proc or return current width
		return self.widthForColumnProc?(column, self.tableColumns[column]) ?? self.tableColumns[column].width
	}

 */
