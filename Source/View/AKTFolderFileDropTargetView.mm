//----------------------------------------------------------------------------------------------------------------------
//	AKTFolderFileDropTargetView.mm			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTFolderFileDropTargetView.h"

#import "NSURL+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: Local data
static	NSString*	NSPasteboardTypeFilenames = @"NSFilenamesPboardType";

//----------------------------------------------------------------------------------------------------------------------
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
	[self registerForDraggedTypes:@[NSPasteboardTypeURL, NSPasteboardTypeFilenames]];
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
	if ([pasteboard.types containsObject:NSPasteboardTypeURL]) {
		// URLs on pasteboard
		NSDictionary<NSString*, id>*	options = @{NSPasteboardURLReadingFileURLsOnlyKey: @YES};
		[urls addObjectsFromArray:[pasteboard readObjectsForClasses:@[[NSURL class]] options:options]];
	} else if ([pasteboard.types containsObject:NSPasteboardTypeFilenames]) {
		// Paths on pasteboard
		NSArray<NSString*>*	paths = [pasteboard propertyListForType:NSPasteboardTypeFilenames];
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
