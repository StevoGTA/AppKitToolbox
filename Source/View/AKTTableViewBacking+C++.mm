//----------------------------------------------------------------------------------------------------------------------
//	AKTTableViewBacking+C++.mm			©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTTableViewBacking+C++.h"

#import "CCoreFoundation.h"
#import "CppWrapper.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTableViewBacking extension

@implementation AKTTableViewBacking (Cpp)

// MARK: Properties

//----------------------------------------------------------------------------------------------------------------------
- (TArray<I<CTableViewItem> >) tableViewItems
{
	// Translate items
	TNArray<I<CTableViewItem> >	tableViewItems;
	for (id object in self.objects)
		// Add item
		tableViewItems += *((I<CTableViewItem>*) ((CppWrapper*) object).object);

	return tableViewItems;
}

//----------------------------------------------------------------------------------------------------------------------
- (TArray<I<CTableViewItem> >) selectedTableViewItems
{
	// Translate items
	TNArray<I<CTableViewItem> >	tableViewItems;
	for (id object in self.selectedObjects)
		// Add item
		tableViewItems += *((I<CTableViewItem>*) ((CppWrapper*) object).object);

	return tableViewItems;
}

//----------------------------------------------------------------------------------------------------------------------
- (TArray<CString>) selectedTableViewItemIDs
{
	return CCoreFoundation::arrayOfStringsFrom((__bridge CFArrayRef) self.selectedObjectIDs);
}

//----------------------------------------------------------------------------------------------------------------------
- (AKTTableViewBackingSortDescriptorsDidChangeProc) cppSortDescriptorsDidChangeProc
{
	return nil;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setCppSortDescriptorsDidChangeProc:
		(AKTTableViewBackingSortDescriptorsDidChangeProc) cppSortDescriptorsDidChangeProc
{
	// Set proc
	self.sortDescriptorsDidChangeProc = ^(NSTableView* tableView, NSArray<NSSortDescriptor*>* sortDescriptors){
		// Setup
		TNArray<SSortDescriptor>	sortDescriptors_;
		for (NSSortDescriptor* sortDescriptor in sortDescriptors)
			// Add
			sortDescriptors_ += SSortDescriptor((__bridge CFStringRef) sortDescriptor.key, sortDescriptor.ascending);

		// Call proc
		cppSortDescriptorsDidChangeProc(sortDescriptors_);
	};
}

//----------------------------------------------------------------------------------------------------------------------
- (AKTTableViewBackingCompareTableViewItemsProc) compareTableViewItemsProc
{
	return nil;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setCompareTableViewItemsProc:(AKTTableViewBackingCompareTableViewItemsProc) compareTableViewItemsProc
{
	// Set proc
	self.compareItemsProc =
			^(TableViewBackingItem* tableViewBackingItem1, TableViewBackingItem* tableViewBackingItem2,
					NSArray<NSSortDescriptor*>* sortDescriptors){
				// Setup
				TNArray<SSortDescriptor>	sortDescriptors_;
				for (NSSortDescriptor* sortDescriptor in sortDescriptors)
					// Add
					sortDescriptors_ +=
							SSortDescriptor((__bridge CFStringRef) sortDescriptor.key, sortDescriptor.ascending);

				return compareTableViewItemsProc(
						*((I<CTableViewItem>*) ((CppWrapper*) tableViewBackingItem1.object).object),
						*((I<CTableViewItem>*) ((CppWrapper*) tableViewBackingItem2.object).object), sortDescriptors_);
			};
}

//----------------------------------------------------------------------------------------------------------------------
- (AKTTableViewBackingTableViewItemViewProc) tableViewItemViewProc
{
	return nil;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setTableViewItemViewProc:(AKTTableViewBackingTableViewItemViewProc) tableViewItemViewProc
{
	// Set proc
	self.objectViewProc =
			^(NSTableView* tableView, NSTableColumn* tableColumn, NSInteger rowIndex, id object){
				// Call proc
				return tableViewItemViewProc(tableView, tableColumn, rowIndex,
						*((I<CTableViewItem>*) ((CppWrapper*) object).object));
			};
}

//----------------------------------------------------------------------------------------------------------------------
- (AKTTableViewBackingTableViewItemHeightProc) tableViewItemHeightProc
{
	return nil;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setTableViewItemHeightProc:(AKTTableViewBackingTableViewItemHeightProc) tableViewItemHeightProc
{
	// Set proc
	self.objectHeightProc = ^(NSTableView* tableView, id object){
		// Call proc
		return [NSNumber
				numberWithDouble:tableViewItemHeightProc(*((I<CTableViewItem>*) ((CppWrapper*) object).object))];
	};
}

//----------------------------------------------------------------------------------------------------------------------
- (AKTTableViewBackingShouldEditTableViewItemProc) shouldEditTableViewItemProc
{
	return nil;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setShouldEditTableViewItemProc:(AKTTableViewBackingShouldEditTableViewItemProc) shouldEditTableViewItemProc
{
	// Set proc
	self.shouldEditObjectProc =
			^(NSTableView* tableView, NSTableColumn* tableColumn, id object){
				// Call proc
				return shouldEditTableViewItemProc(tableView, tableColumn,
						*((I<CTableViewItem>*) ((CppWrapper*) object).object));
			};
}

//----------------------------------------------------------------------------------------------------------------------
- (AKTTableViewBackingPasteboardWriterForItemProc) pasteboardWriterForItemProc
{
	return nil;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setPasteboardWriterForItemProc:(AKTTableViewBackingPasteboardWriterForItemProc) pasteboardWriterForItemProc
{
	// Set proc
	self.pasteboardWriterForObjectProc = ^id<NSPasteboardWriting>(id object){
		return pasteboardWriterForItemProc(*((const I<CTableViewItem>*) ((CppWrapper*) object).object));
	};
}

//----------------------------------------------------------------------------------------------------------------------
- (AKTTableViewBackingValidateDropProc) cppValidateDropProc
{
	return nil;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setCppValidateDropProc:(AKTTableViewBackingValidateDropProc) cppValidateDropProc
{
	// Set proc
	self.validateDropProc = cppValidateDropProc;
}

//----------------------------------------------------------------------------------------------------------------------
- (AKTTableViewBackingAcceptDropProc) cppAcceptDropProc
{
	return nil;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setCppAcceptDropProc:(AKTTableViewBackingAcceptDropProc) cppAcceptDropProc
{
	// Set proc
	self.acceptDropProc = cppAcceptDropProc;
}

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (void) setCppSortDescriptors:(const TArray<SSortDescriptor>&) sortDescriptors
{
	// Convert
	NSMutableArray<NSSortDescriptor*>*	sortDescriptors_ = [[NSMutableArray alloc] init];
	for (TArray<SSortDescriptor>::Iterator iterator = sortDescriptors.getIterator(); iterator; iterator++)
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
- (void) setTableViewItems:(const TArray<I<CTableViewItem> >&) tableViewItems
{
	// Set content
	[self setItems:[AKTTableViewBacking tableViewBackingItemsFor:tableViewItems]];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) addTableViewItems:(const TArray<I<CTableViewItem> >&) tableViewItems
{
	// Add content
	[self addItems:[AKTTableViewBacking tableViewBackingItemsFor:tableViewItems]];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) removeTableViewItems:(const TArray<I<CTableViewItem> >&) tableViewItems
{
	// Remove content
	[self removeItems:[AKTTableViewBacking tableViewBackingItemsFor:tableViewItems]];
}

//----------------------------------------------------------------------------------------------------------------------
- (I<CTableViewItem>) tableViewItemAtRow:(NSInteger) row
{
	return *((I<CTableViewItem>*) ((CppWrapper*) [self objectAtRow:row]).object);
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setSelectedTableViewItemIDs:(const TArray<CString>&) tableViewItemIDs
{
	// Select table view items
	[self.tableView
			selectRowIndexes:
					[self rowIndexesForObjectIDs:
							(__bridge NSArray<NSString*>*) *CCoreFoundation::arrayRefFrom(tableViewItemIDs)]
			byExtendingSelection:NO];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) reloadTableColumn:(const CTableColumn&) tableColumn
{
	// Reload
	[self.tableView reloadColumnFor:(__bridge NSString*) tableColumn.getIdentifier().getOSString()];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) reloadTableColumnIdentifier:(const CString&) tableColumnIdentifier
{
	// Reload
	[self.tableView reloadColumnFor:(__bridge NSString*) tableColumnIdentifier.getOSString()];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) reloadTableViewItem:(const CTableViewItem&) tableViewItem
		tableColumnIdentifiers:(const OV<TSet<CString> >&) tableColumnIdentifiers
{
	// Reload cells - the given columns, or all columns
	[self.tableView
			reloadDataForRowIndexes:
					[self rowIndexesForObjectIDs:@[(__bridge NSString*) tableViewItem.getID().getOSString()]]
			columnIndexes:
					tableColumnIdentifiers.hasValue() ?
							[self columnIndexesForTableColumnIdentifiers:*tableColumnIdentifiers] :
							[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.tableView.numberOfColumns)]];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) reloadTableViewItems:(const TArray<I<CTableViewItem> >&) tableViewItems
		tableColumnIdentifiers:(const OV<TSet<CString> >&) tableColumnIdentifiers
{
	// Reload cells - the given columns, or all columns
	[self.tableView
			reloadDataForRowIndexes:
					[self rowIndexesForObjectIDs:
							(__bridge NSArray<NSString*>*)
									*CCoreFoundation::arrayRefFrom(CTableViewItem::getIDs(tableViewItems))]
			columnIndexes:
					tableColumnIdentifiers.hasValue() ?
							[self columnIndexesForTableColumnIdentifiers:*tableColumnIdentifiers] :
							[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.tableView.numberOfColumns)]];
}

// MARK: Private methods

//----------------------------------------------------------------------------------------------------------------------
+ (NSArray<TableViewBackingItem*>*) tableViewBackingItemsFor:(const TArray<I<CTableViewItem> >&) tableViewItems
{
	// Convert array
	NSMutableArray<TableViewBackingItem*>*	tableViewBackingItems = [[NSMutableArray alloc] init];
	for (TArray<I<CTableViewItem> >::Iterator iterator = tableViewItems.getIterator(); iterator; iterator++)
		// Add Table View Backing Item
		[tableViewBackingItems
			addObject:
					[[TableViewBackingItem alloc]
							initWithID:[(__bridge NSString*) (*iterator)->getID().getOSString() copy]
							object:
									[CppWrapper wrapperWith:new I<CTableViewItem>(*iterator)
											deleteProc:^(const void* object){ delete (I<CTableViewItem>*) object; }]]];

	return tableViewBackingItems;
}

//----------------------------------------------------------------------------------------------------------------------
- (NSIndexSet*) columnIndexesForTableColumnIdentifiers:(const TSet<CString>&) tableColumnIdentifiers
{
	// Compose column indexes
	NSMutableIndexSet*	indexSet = [[NSMutableIndexSet alloc] init];
	[self.tableView.tableColumns
			enumerateObjectsUsingBlock:^(NSTableColumn* tableColumn, NSUInteger index, BOOL* stop){
				// Check identifier
				if (tableColumnIdentifiers.contains(CString((__bridge CFStringRef) tableColumn.identifier)))
					// Add index
					[indexSet addIndex:index];
			}];

	return indexSet;
}

@end
