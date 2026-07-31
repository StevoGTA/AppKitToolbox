//----------------------------------------------------------------------------------------------------------------------
//	AKTPathView+C++.h			©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "CFilesystemPath.h"

#import <AppKit/AppKit.h>

#import "Swift.h"

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTPathView extension

@interface AKTPathView (Cpp)

// MARK: Instance methods

- (void) setCppRootPath:(const OV<CFilesystemPath>&) filesystemPath;
- (void) setCppPath:(const CFilesystemPath&) filesystemPath;

@end

NS_ASSUME_NONNULL_END
