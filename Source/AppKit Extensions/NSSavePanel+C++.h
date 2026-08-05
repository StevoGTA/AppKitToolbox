//----------------------------------------------------------------------------------------------------------------------
//	NSSavePanel+C++.h			©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "CFile.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSSavePanel extension

@interface NSSavePanel (Cpp)

// MARK: Properties

@property (nonatomic, readonly)	CFile	file;

@property (nonatomic, assign) 	CString	nameFieldString;
@property (nonatomic, assign)	CString	extensionString;

@end

NS_ASSUME_NONNULL_END
