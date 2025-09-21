//----------------------------------------------------------------------------------------------------------------------
//	AKTEditableRemovableViewController.h			©2025 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "AKTRemovableViewController.h"

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: Types

typedef	void	(^AKTEditableRemovableViewControllerContentChangedProc)(void);

//----------------------------------------------------------------------------------------------------------------------
// MARK: - AKTEditableRemovableViewController

@interface AKTEditableRemovableViewController : AKTRemovableViewController

// MARK: Properties

@property (nonatomic, strong)	AKTEditableRemovableViewControllerContentChangedProc	contentChangedProc;

// MARK: Instance methods

- (void) setEditing:(BOOL) editing animated:(BOOL) animated;

// MARK: Instance methods for subclasses to use

- (void) noteContentChanged;

// MARK: Instance methods for subclasses to implement as needed

- (BOOL) isContentValid;

@end

NS_ASSUME_NONNULL_END
