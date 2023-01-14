//----------------------------------------------------------------------------------------------------------------------
//	AKTURLControl+C++.mm			©2021 Monkey Tools, LLC		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTURLControl+C++.h"

#import "NSString+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTURLControl extension

@implementation AKTURLControl (Cpp)

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (void) setupWithCString:(const CString&) string urlCString:(const CString&) urlString
{
	// Setup
	[self setupWithString:[NSString stringForCString:string]
			url:[NSURL URLWithString:[NSString stringForCString:urlString]]];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setupWithCString:(const CString&) string urlCString:(const CString&) urlString font:(NSFont*) font
{
	// Setup
	[self setupWithString:[NSString stringForCString:string]
			url:[NSURL URLWithString:[NSString stringForCString:urlString]] font:font];
}

@end
