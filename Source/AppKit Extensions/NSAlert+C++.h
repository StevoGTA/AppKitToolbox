//----------------------------------------------------------------------------------------------------------------------
//	NSAlert+C++.h			©2026 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "SError.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSAlert extension

@interface NSAlert (Cpp)

// MARK: Class methods

+ (instancetype) informationalWithMessage:(NSString*) message error:(const SError&) error
		buttonTitle:(NSString*) buttonTitle;
+ (instancetype) warningWithMessage:(NSString*) message error:(const SError&) error
		buttonTitle:(NSString*) buttonTitle;
+ (instancetype) criticalWithMessage:(NSString*) message error:(const SError&) error
		buttonTitle:(NSString*) buttonTitle;

@end

NS_ASSUME_NONNULL_END
