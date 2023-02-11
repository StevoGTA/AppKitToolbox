//----------------------------------------------------------------------------------------------------------------------
//	NSNib+Extensions.h			©2023 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: - NSNib extension

@interface NSNib (Extensions)

// MARK: Class methods

+ (nullable NSView*) instantiateViewWithClass:(Class) clas fromNibNamed:(NSString*) nibName bundle:(NSBundle*) bundle;
+ (nullable NSView*) instantiateViewWithClass:(Class) clas fromNibNamed:(NSString*) nibName;

@end

NS_ASSUME_NONNULL_END
