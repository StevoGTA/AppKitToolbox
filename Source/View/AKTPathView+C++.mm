//----------------------------------------------------------------------------------------------------------------------
//	AKTPathView+C++.mm			©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTPathView+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTPathView extension

@implementation AKTPathView (Cpp)

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (void) setCppRootPath:(const OV<CFilesystemPath>&) filesystemPath
{
	// Set
	self.rootPath = filesystemPath.hasValue() ? (__bridge NSString*) filesystemPath->getString().getOSString() : nil;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setCppPath:(const CFilesystemPath&) filesystemPath
{
	// Set
	self.path = (__bridge NSString*) filesystemPath.getString().getOSString();
}

@end
