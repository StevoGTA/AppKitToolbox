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
+ (instancetype) informationalWithMessage:(const CString&) message accessoryView:(NSView*) accessoryView
		confirmButtonTitle:(const CString&) confirmButtonTitle cancelButtonTitle:(const CString&) cancelButtonTitle;

+ (instancetype) warningWithMessage:(NSString*) message error:(const SError&) error
		buttonTitle:(NSString*) buttonTitle;
+ (instancetype) warningWithMessageString:(const CString&) messageString error:(const SError&) error
		buttonTitleString:(const CString&) buttonTitleString;
+ (instancetype) warningWithMessage:(const CString&) message confirmButtonTitle:(const CString&) confirmButtonTitle
		cancelButtonTitle:(const CString&) cancelButtonTitle;

+ (instancetype) criticalWithMessage:(NSString*) message error:(const SError&) error
		buttonTitle:(NSString*) buttonTitle;

@end

NS_ASSUME_NONNULL_END
