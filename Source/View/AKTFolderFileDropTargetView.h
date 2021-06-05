//----------------------------------------------------------------------------------------------------------------------
//	AKTFolderFileDropTargetView.h			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "SFoldersFiles.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTFolderFileDropTargetView
@interface AKTFolderFileDropTargetView : NSView

// MARK: Types

typedef void	(^FoldersFilesProc)(const SFoldersFiles& foldersFiles);

// MARK: Properties

@property (nonatomic, strong)	FoldersFilesProc	foldersFilesProc;

// MARK: Instance methods

@end

NS_ASSUME_NONNULL_END
