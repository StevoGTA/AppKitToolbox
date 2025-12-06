//----------------------------------------------------------------------------------------------------------------------
//	AKTURLControl+C++.mm			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTURLControl+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTURLControl extension

@implementation AKTURLControl (Cpp)

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (void) setupWithCString:(const CString&) string urlCString:(const CString&) urlString
{
	// Setup
	[self setupWithString:(__bridge NSString*) string.getOSString()
			url:[NSURL URLWithString:(__bridge NSString*) urlString.getOSString()]];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setupWithCString:(const CString&) string urlCString:(const CString&) urlString font:(NSFont*) font
{
	// Setup
	[self setupWithString:(__bridge NSString*) string.getOSString()
			url:[NSURL URLWithString:(__bridge NSString*) urlString.getOSString()] font:font];
}

@end
