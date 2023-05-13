//----------------------------------------------------------------------------------------------------------------------
//	NSPathControl+C++.mm			©2023 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "NSPathControl+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSPathControl extension

@implementation NSPathControl (Cpp)

// MARK: Properties

//----------------------------------------------------------------------------------------------------------------------
- (CFolder) cFolder
{
	return CFolder(CFilesystemPath(CString((__bridge OSStringType) self.URL.path)));
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setCFolder:(CFolder) folder
{
	self.URL = [NSURL fileURLWithPath:(__bridge NSString*) folder.getFilesystemPath().getString().getOSString()];
}

@end
