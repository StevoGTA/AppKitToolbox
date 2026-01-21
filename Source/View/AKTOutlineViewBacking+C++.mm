//----------------------------------------------------------------------------------------------------------------------
//	AKTOutlineViewBacking+C++.mm			©2025 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTOutlineViewBacking+C++.h"

#import "CppWrapper.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTOutlineViewBacking extension

@implementation AKTOutlineViewBacking (Cpp)

// MARK: Property methods

//----------------------------------------------------------------------------------------------------------------------
- (TArray<I<COutlineViewItem> >) selectedOutlineViewItems
{
	// Translate items
	TNArray<I<COutlineViewItem> >	outlineViewItems;
	for (id object in self.selectedObjects)
		// Add item
		outlineViewItems += *((I<COutlineViewItem>*) ((CppWrapper*) object).object);

	return outlineViewItems;
}

//----------------------------------------------------------------------------------------------------------------------
- (TArray<I<COutlineViewItem> >) topLevelOutlineViewItems
{
	// Translate items
	TNArray<I<COutlineViewItem> >	outlineViewItems;
	for (id object in self.topLevelObjects)
		// Add item
		outlineViewItems += *((I<COutlineViewItem>*) ((CppWrapper*) object).object);

	return outlineViewItems;
}

//----------------------------------------------------------------------------------------------------------------------
- (AKTOutlineViewBackingSortDescriptorsDidChangeProc) cppSortDescriptorsDidChangeProc
{
	return nil;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setCppSortDescriptorsDidChangeProc:
		(AKTOutlineViewBackingSortDescriptorsDidChangeProc) cppSortDescriptorsDidChangeProc
{
	// Set proc
	self.sortDescriptorsDidChangeProc = ^(NSOutlineView* outlineView, NSArray<NSSortDescriptor*>* sortDescriptors){
		// Setup
		TNArray<SSortDescriptor>	sortDescriptors_;
		for (NSSortDescriptor* sortDescriptor in sortDescriptors)
			// Add
			sortDescriptors_ +=
					SSortDescriptor((__bridge CFStringRef) sortDescriptor.key, sortDescriptor.ascending);

		// Call proc
		cppSortDescriptorsDidChangeProc(sortDescriptors_);
	};
}

//----------------------------------------------------------------------------------------------------------------------
- (AKTOutlineViewBackingCompareOutlineViewItemsProc) compareOutlineViewItemsProc
{
	return nil;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setCompareOutlineViewItemsProc:(AKTOutlineViewBackingCompareOutlineViewItemsProc) compareOutlineViewItemsProc
{
	// Set proc
	self.compareObjectsProc =
			^(OutlineViewBackingItem* outlineViewBackingItem1, OutlineViewBackingItem* outlineViewBackingItem2,
					NSArray<NSSortDescriptor*>* sortDescriptors){
				// Setup
				TNArray<SSortDescriptor>	sortDescriptors_;
				for (NSSortDescriptor* sortDescriptor in sortDescriptors)
					// Add
					sortDescriptors_ +=
							SSortDescriptor((__bridge CFStringRef) sortDescriptor.key, sortDescriptor.ascending);

				return compareOutlineViewItemsProc(
						*((I<COutlineViewItem>*) ((CppWrapper*) outlineViewBackingItem1.object).object),
						*((I<COutlineViewItem>*) ((CppWrapper*) outlineViewBackingItem2.object).object),
						sortDescriptors_);
			};
}

//----------------------------------------------------------------------------------------------------------------------
- (AKTOutlineViewBackingReloadChildOutlineViewItemsProc) reloadChildOutlineViewItemsProc
{
	return nil;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setReloadChildOutlineViewItemsProc:
		(AKTOutlineViewBackingReloadChildOutlineViewItemsProc) reloadChildOutlineViewItemsProc
{
	// Set proc
	self.reloadChildItemsProc = ^NSArray<OutlineViewBackingItem*>*(id parentObject){
		// Call proc
		return [AKTOutlineViewBacking
				outlineViewBackingItemsFor:
						reloadChildOutlineViewItemsProc(*((I<COutlineViewItem>*) ((CppWrapper*) parentObject).object))];
	};
}

//----------------------------------------------------------------------------------------------------------------------
- (AKTOutlineViewBackingOutlineItemViewProc) outlineViewItemViewProc
{
	return nil;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setOutlineViewItemViewProc:(AKTOutlineViewBackingOutlineItemViewProc) outlineViewItemViewProc
{
	// Set proc
	self.itemViewProc =
			^(NSOutlineView* outlineView, NSTableColumn* tableColumn, NSInteger rowIndex, id object){
				// Call proc
				return outlineViewItemViewProc(outlineView, tableColumn, rowIndex,
						*((I<COutlineViewItem>*) ((CppWrapper*) object).object));
			};
}

//----------------------------------------------------------------------------------------------------------------------
- (AKTOutlineViewBackingShouldEditItemProc) outlineViewBackingShouldEditItemProc
{
	return nil;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setOutlineViewBackingShouldEditItemProc:
		(AKTOutlineViewBackingShouldEditItemProc) outlineViewBackingShouldEditItemProc
{
	// Set proc
	self.shouldEditItemProc =
			^(NSOutlineView* outlineView, NSTableColumn* tableColumn, id object){
				// Call proc
				return outlineViewBackingShouldEditItemProc(outlineView, tableColumn,
						*((I<COutlineViewItem>*) ((CppWrapper*) object).object));
			};
}

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (void) setCppSortDescriptors:(const TArray<SSortDescriptor>&) sortDescriptors
{
	// Convert
	NSMutableArray<NSSortDescriptor*>*	sortDescriptors_ = [[NSMutableArray alloc] init];
	for (TIteratorD<SSortDescriptor> iterator = sortDescriptors.getIterator(); iterator.hasValue(); iterator.advance())
		// Add
		[sortDescriptors_
				addObject:
						[NSSortDescriptor
								sortDescriptorWithKey:(__bridge NSString*) iterator->getIdentifier().getOSString()
								ascending:iterator->getIsAscending()]];

	// Set sort descriptors
	[self setSortDescriptors:sortDescriptors_];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setOutlineViewItems:(const TArray<I<COutlineViewItem> >&) outlineViewItems
{
	// Set content
	[self setItems:[AKTOutlineViewBacking outlineViewBackingItemsFor:outlineViewItems] forParentItemID:nil];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) addOutlineViewItems:(const TArray<I<COutlineViewItem> >&) outlineViewItems
{
	// Add content
	[self addItems:[AKTOutlineViewBacking outlineViewBackingItemsFor:outlineViewItems] toParentItemID:nil];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) removeOutlineViewItems:(const TArray<I<COutlineViewItem> >&) outlineViewItems
{
	// Remove content
	[self removeItems:[AKTOutlineViewBacking outlineViewBackingItemsFor:outlineViewItems] fromParentItemID:nil];
}

//----------------------------------------------------------------------------------------------------------------------
- (I<COutlineViewItem>) outlineViewItemAtRow:(NSInteger) row
{
	return *((I<COutlineViewItem>*) ((CppWrapper*) [self objectAtRow:row]).object);
}

//----------------------------------------------------------------------------------------------------------------------
- (void) reloadTableColumn:(const CTableColumn&) tableColumn
{
	// Reload
	[self.outlineView reloadColumnFor:(__bridge NSString*) tableColumn.getIdentifier().getOSString()];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) reloadTableViewItem:(const CTableViewItem&) tableViewItem
		tableColumnIdentifiers:(const OV<TSet<CString> >&) tableColumnIdentifiers
{
	// Check if have identifiers
	if (tableColumnIdentifiers.hasValue())
		// Reload specific cells
		[self.outlineView reloadDataForRowIndexes:[self rowIndexForTableViewItem:tableViewItem]
				columnIndexes:[self columnIndexesForTableColumnIdentifiers:*tableColumnIdentifiers]];
	else
		// Reload whole item
		[self.outlineView reloadItem:(__bridge NSString*) tableViewItem.getID().getOSString()];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) reloadOutlineViewItems:(TArray<I<COutlineViewItem> >&) outlineViewItems
		tableColumn:(const CTableColumn&) tableColumn
{
	// Reload cells
	[self.outlineView reloadDataForRowIndexes:[self rowIndexesForOutlineViewItems:outlineViewItems]
			columnIndexes:[self columnIndexesForTableColumnIdentifiers:TSSet<CString>(tableColumn.getIdentifier())]];
}

// MARK: Private methods

//----------------------------------------------------------------------------------------------------------------------
+ (NSArray<OutlineViewBackingItem*>*) outlineViewBackingItemsFor:(const TArray<I<COutlineViewItem> >&) outlineViewItems
{
	// Convert array
	NSMutableArray<OutlineViewBackingItem*>*	outlineViewBackingItems = [[NSMutableArray alloc] init];
	for (TIteratorD<I<COutlineViewItem> > iterator = outlineViewItems.getIterator(); iterator.hasValue();
			iterator.advance())
		// Add Outline View Backing Item
		[outlineViewBackingItems
			addObject:
					[[OutlineViewBackingItem alloc]
							initWithID:[(__bridge NSString*) (*iterator)->getID().getOSString() copy]
							object:
									[CppWrapper wrapperWith:new I<COutlineViewItem>(*iterator)
											deleteProc:^(const void* object){ delete (I<COutlineViewItem>*) object; }]
							childCount:(*iterator)->getChildCount()]];

	return outlineViewBackingItems;
}

//----------------------------------------------------------------------------------------------------------------------
- (NSIndexSet*) rowIndexForTableViewItem:(const CTableViewItem&) tableViewItem
{
	// Setup
	NSString*	item = (__bridge NSString*) tableViewItem.getID().getOSString();

	return [[NSIndexSet alloc] initWithIndex:[self.outlineView rowForItem:item]];
}

//----------------------------------------------------------------------------------------------------------------------
- (NSIndexSet*) rowIndexesForOutlineViewItems:(const TArray<I<COutlineViewItem> >&) outlineViewItems
{
	// Compose row indexes
	NSMutableIndexSet*	indexSet = [[NSMutableIndexSet alloc] init];
	for (TIteratorD<I<COutlineViewItem> > iterator = outlineViewItems.getIterator(); iterator.hasValue();
			iterator.advance())
		// Add index
		[indexSet addIndex:[self.outlineView rowForItem:(__bridge NSString*) (*iterator)->getID().getOSString()]];

	return indexSet;
}

//----------------------------------------------------------------------------------------------------------------------
- (NSIndexSet*) columnIndexesForTableColumnIdentifiers:(const TSet<CString>&) tableColumnIdentifiers
{
	// Compose column indexes
	NSMutableIndexSet*	indexSet = [[NSMutableIndexSet alloc] init];
	[self.outlineView.tableColumns
			enumerateObjectsUsingBlock:^(NSTableColumn* tableColumn, NSUInteger index, BOOL* stop) {
				// Check identifier
				if (tableColumnIdentifiers.contains(CString((__bridge CFStringRef) tableColumn.identifier)))
					// Add index
					[indexSet addIndex:index];
			}];

	return indexSet;
}

@end
