//----------------------------------------------------------------------------------------------------------------------
//	AKTEditableRemovableViewController.h			©2025 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "AKTRemovableViewController.h"

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTEditableRemovableViewController
@interface AKTEditableRemovableViewController : AKTRemovableViewController

// MARK: Instance methods

- (void) setEditing:(BOOL) editing animated:(BOOL) animated;

@end

NS_ASSUME_NONNULL_END
