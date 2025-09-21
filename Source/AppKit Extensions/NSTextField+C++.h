//----------------------------------------------------------------------------------------------------------------------
//	NSTextField+C++.h			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "CString.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSTextField extension

@interface NSTextField (Cpp)

// MARK: Properties

@property (nonatomic, assign)			CString	string;
@property (nonatomic, assign, readonly)	OV<CString>	ovString;

// MARK: Class methods

+ (instancetype) createWithString:(const CString&) string;
+ (instancetype) createWithString:(const CString&) string controlSize:(NSControlSize) controlSize;

// MARK: Lifecycle methods

- (instancetype) initWithString:(const CString&) string;
- (instancetype) initWithString:(const CString&) string controlSize:(NSControlSize) controlSize;

// MARK: Instance methods

- (void) setString:(const CString&) string animated:(BOOL) animated;

@end

NS_ASSUME_NONNULL_END
