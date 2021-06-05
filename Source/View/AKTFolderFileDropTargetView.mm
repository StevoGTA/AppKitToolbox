//----------------------------------------------------------------------------------------------------------------------
//	AKTFolderFileDropTargetView.mm			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTFolderFileDropTargetView.h"

#import "NSURL+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK :AKTFolderFileDropTargetView

@implementation AKTFolderFileDropTargetView

// MARK: Lifecycle methods

//----------------------------------------------------------------------------------------------------------------------
- (void) awakeFromNib
{
	// Do super
	[super awakeFromNib];

	// Register for dragged types
	[self registerForDraggedTypes:@[NSURLPboardType, NSFilenamesPboardType]];
}

// MARK: NSDraggingDestination methods

//----------------------------------------------------------------------------------------------------------------------
- (NSDragOperation) draggingEntered:(id <NSDraggingInfo>) draggingInfo
//----------------------------------------------------------------------------------------------------------------------
{
	return NSDragOperationCopy;
}

//----------------------------------------------------------------------------------------------------------------------
- (BOOL) performDragOperation:(id <NSDraggingInfo>) draggingInfo
//----------------------------------------------------------------------------------------------------------------------
{
	// Setup
	NSPasteboard*	pasteboard = draggingInfo.draggingPasteboard;
	NSMutableArray*	urls = [NSMutableArray array];

	// Retrieve URLs
	if ([pasteboard.types containsObject:NSURLPboardType]) {
		// URLs on pasteboard
		NSDictionary<NSString*, id>*	options = @{NSPasteboardURLReadingFileURLsOnlyKey: @YES};
		[urls addObjectsFromArray:[pasteboard readObjectsForClasses:@[[NSURL class]] options:options]];
	} else if ([pasteboard.types containsObject:NSFilenamesPboardType]) {
		// Paths on pasteboard
		NSArray<NSString*>*	paths = [pasteboard propertyListForType:NSFilenamesPboardType];
		for (NSString* path in paths)
			// Add url
			[urls addObject:[NSURL fileURLWithPath:path]];
	} else
		// Unknown
		return NO;

	// Call proc
	self.foldersFilesProc([NSURL foldersFilesFor:urls]);

	return YES;
}

@end
