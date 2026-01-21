//----------------------------------------------------------------------------------------------------------------------
//	NSTableView+C++.h			©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#include "CString.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSTableView extension

@interface NSTableView (Cpp)

// MARK: Instance methods

- (nullable NSTableColumn*) tableColumnWithIdentifierString:(const CString&) string;

@end

NS_ASSUME_NONNULL_END
