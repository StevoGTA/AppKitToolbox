//----------------------------------------------------------------------------------------------------------------------
//	NSPasteboardItem+C++.h			©2026 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#include "CString.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSPasteboardItem extension

@interface NSPasteboardItem (Cpp)

// MARK: Class methods

+ (instancetype) pasteboardItemWithString:(const CString&) string forType:(NSString*) type;

@end

NS_ASSUME_NONNULL_END
