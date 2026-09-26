//----------------------------------------------------------------------------------------------------------------------
//	AKTTableViewBacking+C++.h			©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "CTableColumn.h"
#import "CTableViewItem.h"
#import "SSortDescriptor.h"

#import <AppKit/AppKit.h>

#import "Swift.h"

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTableViewBacking extension

typedef	void								(^AKTTableViewBackingSortDescriptorsDidChangeProc)(
												const TArray<SSortDescriptor>& sortDescriptors);
typedef	BOOL								(^AKTTableViewBackingCompareTableViewItemsProc)(
												const I<CTableViewItem>& tableViewItem1,
												const I<CTableViewItem>& tableViewItem2,
												const TArray<SSortDescriptor>& sortDescriptors);

typedef	CGFloat								(^AKTTableViewBackingTableViewItemHeightProc)(
												const I<CTableViewItem>& tableViewItem);

typedef	NSView*					_Nullable	(^AKTTableViewBackingTableViewItemViewProc)(NSTableView* tableView,
												NSTableColumn* tableColumn, NSInteger rowIndex,
												const I<CTableViewItem>& tableViewItem);

typedef	BOOL								(^AKTTableViewBackingShouldEditTableViewItemProc)(NSTableView* tableView,
												NSTableColumn* tableColumn, const I<CTableViewItem>& tableViewItem);

typedef	id<NSPasteboardWriting> _Nullable	(^AKTTableViewBackingPasteboardWriterForItemProc)(
												const I<CTableViewItem>& tableViewItem);
typedef	NSDragOperation						(^AKTTableViewBackingValidateDropProc)(NSTableView* tableView,
												id<NSDraggingInfo> info, NSInteger row,
												NSTableViewDropOperation dropOperation);
typedef	BOOL								(^AKTTableViewBackingAcceptDropProc)(id<NSDraggingInfo> info,
												NSInteger row, NSTableViewDropOperation dropOperation);

@interface AKTTableViewBacking (Cpp)

// MARK: Properties

@property (nonatomic, readonly)	TArray<I<CTableViewItem> >						tableViewItems;

@property (nonatomic, readonly)	TArray<I<CTableViewItem> >						selectedTableViewItems;
@property (nonatomic, readonly)	TArray<CString>									selectedTableViewItemIDs;

@property (nonatomic, assign)	AKTTableViewBackingSortDescriptorsDidChangeProc	cppSortDescriptorsDidChangeProc;
@property (nonatomic, assign)	AKTTableViewBackingCompareTableViewItemsProc	compareTableViewItemsProc;

@property (nonatomic, assign)	AKTTableViewBackingTableViewItemViewProc		tableViewItemViewProc;
@property (nonatomic, assign)	AKTTableViewBackingTableViewItemHeightProc		tableViewItemHeightProc;

@property (nonatomic, assign)	AKTTableViewBackingShouldEditTableViewItemProc	shouldEditTableViewItemProc;

@property (nonatomic, assign)	AKTTableViewBackingPasteboardWriterForItemProc	pasteboardWriterForItemProc;
@property (nonatomic, assign)	AKTTableViewBackingValidateDropProc				cppValidateDropProc;
@property (nonatomic, assign)	AKTTableViewBackingAcceptDropProc				cppAcceptDropProc;

// MARK: Instance methods

- (void) setCppSortDescriptors:(const TArray<SSortDescriptor>&) sortDescriptors;

- (void) setTableViewItems:(const TArray<I<CTableViewItem> >&) tableViewItems;
- (void) addTableViewItems:(const TArray<I<CTableViewItem> >&) tableViewItems;
- (void) removeTableViewItems:(const TArray<I<CTableViewItem> >&) tableViewItems;
- (I<CTableViewItem>) tableViewItemAtRow:(NSInteger) row;

- (void) setSelectedTableViewItemIDs:(const TArray<CString>&) tableViewItemIDs;

- (void) reloadTableColumn:(const CTableColumn&) tableColumn;
- (void) reloadTableColumnIdentifier:(const CString&) tableColumnIdentifier;

- (void) reloadTableViewItem:(const CTableViewItem&) tableViewItem
		tableColumnIdentifiers:(const OV<TSet<CString> >&) tableColumnIdentifiers;

- (void) reloadTableViewItems:(const TArray<I<CTableViewItem> >&) tableViewItems
		tableColumnIdentifiers:(const OV<TSet<CString> >&) tableColumnIdentifiers;

@end

NS_ASSUME_NONNULL_END
