//----------------------------------------------------------------------------------------------------------------------
//	NSPathControl+C++.mm			©2023 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "NSPathControl+C++.h"

#import "NSString+C++.h"

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
	self.URL = [NSURL fileURLWithPath:[NSString stringForCString:folder.getFilesystemPath().getString()]];
}

@end
