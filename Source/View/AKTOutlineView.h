//----------------------------------------------------------------------------------------------------------------------
//	AKTOutlineView.h			©2026 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTOutlineView
@interface AKTOutlineView : NSOutlineView

// MARK: Properties

@property (nonatomic, assign)	BOOL	isOptionClickToBeginEditingEnabled;

@end

NS_ASSUME_NONNULL_END
