//----------------------------------------------------------------------------------------------------------------------
//	AKTURLControl+C++.h			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#include "CString.h"
#include "Swift.h"		// AKTURLControl is defined in Swift so must include its interface somehow

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTURLControl extension

@interface AKTURLControl (Cpp)

// MARK: Instance methods

- (void) setupWithCString:(const CString&) string urlCString:(const CString&) urlString;
- (void) setupWithCString:(const CString&) string urlCString:(const CString&) urlString font:(NSFont*) font;

@end

NS_ASSUME_NONNULL_END
