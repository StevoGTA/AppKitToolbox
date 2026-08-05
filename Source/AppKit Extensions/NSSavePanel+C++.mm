//----------------------------------------------------------------------------------------------------------------------
//	NSSavePanel+C++.mm			©2026 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "NSSavePanel+C++.h"

#import "NSString+C++.h"
#import "NSURL+C++.h"

#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSSavePanel extension

@implementation NSSavePanel (Cpp)

// MARK: Properties

//----------------------------------------------------------------------------------------------------------------------
- (CFile) file
{
	return self.URL.file;
}

//----------------------------------------------------------------------------------------------------------------------
- (CString) nameFieldString
{
	return CString((__bridge CFStringRef) self.nameFieldStringValue);
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setNameFieldString:(CString) string
{
	self.nameFieldStringValue = (__bridge NSString*) string.getOSString();
}

//----------------------------------------------------------------------------------------------------------------------
- (CString) extensionString
{
	// Setup
	UTType*	type = self.allowedContentTypes.firstObject;

	return (type != nil) ? CString((__bridge CFStringRef) type.preferredFilenameExtension) : CString::mEmpty;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setExtensionString:(CString) string
{
	self.allowedContentTypes = @[[UTType typeWithFilenameExtension:(__bridge NSString*) string.getOSString()]];
}

@end
