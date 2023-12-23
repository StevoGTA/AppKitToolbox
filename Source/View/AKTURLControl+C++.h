//----------------------------------------------------------------------------------------------------------------------
//	AKTURLControl+C++.h			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "CString.h"

#import <AppKit/AppKit.h>
#import "Swift.h"		// AKTURLControl is defined in Swift so must include its interface somehow

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTURLControl extension

@interface AKTURLControl (Cpp)

// MARK: Instance methods

- (void) setupWithCString:(const CString&) string urlCString:(const CString&) urlString;
- (void) setupWithCString:(const CString&) string urlCString:(const CString&) urlString font:(NSFont*) font;

@end

NS_ASSUME_NONNULL_END
