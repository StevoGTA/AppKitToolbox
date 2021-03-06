//----------------------------------------------------------------------------------------------------------------------
//	AKTTreeViewBackingAdapter.mm			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTTreeViewBackingAdapter.h"

#import "CTreeViewBacking.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTreeViewBackingAdapter

@interface AKTTreeViewBackingAdapter () <NSOutlineViewDataSource, NSOutlineViewDelegate>

// MARK: Properties

@property (nonatomic, assign)	CTreeViewBacking*	treeViewBacking;

@end

@implementation AKTTreeViewBackingAdapter

// MARK: Lifecycle methods

//----------------------------------------------------------------------------------------------------------------------
- (instancetype) initWithOutlineView:(NSOutlineView*) outlineView
{
	self = [super init];
	if (self != nil) {
		// Setup
		self.treeViewBacking = new CTreeViewBacking();

		// Setup NSOutlineView
		outlineView.dataSource = self;
		outlineView.delegate = self;
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
return 0;
}

//----------------------------------------------------------------------------------------------------------------------
- (id) outlineView:(NSOutlineView*) outlineView child:(NSInteger)index ofItem:(id) item
{
return nil;
}

//----------------------------------------------------------------------------------------------------------------------
- (BOOL) outlineView:(NSOutlineView*) outlineView isItemExpandable:(id) item
{
return NO;
}

//----------------------------------------------------------------------------------------------------------------------
- (id) outlineView:(NSOutlineView*) outlineView objectValueForTableColumn:(NSTableColumn*) tableColumn byItem:(id) item
{
return nil;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) outlineView:(NSOutlineView*) outlineView sortDescriptorsDidChange:(NSArray<NSSortDescriptor *>*) oldDescriptors
{
}

// MARK: NSOutlineViewDelegate methods

//----------------------------------------------------------------------------------------------------------------------
- (NSView*) outlineView:(NSOutlineView*) outlineView viewForTableColumn:(NSTableColumn*) tableColumn item:(id) item
{
return nil;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) outlineViewItemDidExpand:(NSNotification*) notification
{
}

//----------------------------------------------------------------------------------------------------------------------
- (void) outlineViewItemDidCollapse:(NSNotification*) notification
{
}

//----------------------------------------------------------------------------------------------------------------------
- (BOOL) outlineView:(NSOutlineView*) outlineView shouldSelectItem:(id) item
{
return NO;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) outlineViewSelectionDidChange:(NSNotification*) notification
{
}

//----------------------------------------------------------------------------------------------------------------------
- (BOOL) outlineView:(NSOutlineView*) outlineView isGroupItem:(id) item
{
return NO;
}

//----------------------------------------------------------------------------------------------------------------------
- (CGFloat) outlineView:(NSOutlineView*) outlineView sizeToFitWidthOfColumn:(NSInteger) column
{
return 0.0;
}

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (void) setTopLevelTreeItems:(const TArray<I<CTreeItem> >&) topLevelTreeItems
{
	//
	self.treeViewBacking->set(topLevelTreeItems);
}

//----------------------------------------------------------------------------------------------------------------------
- (void) addTopLevelTreeItems:(const TArray<I<CTreeItem> >&) topLevelTreeItems
{
// Temporary implementation
TNArray<I<CTreeItem> >*	treeItems = new TNArray<I<CTreeItem> >(topLevelTreeItems);
	dispatch_async(dispatch_get_main_queue(), ^{
		self.treeViewBacking->add(*treeItems);
		delete treeItems;
	});
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
