//----------------------------------------------------------------------------------------------------------------------
//	AKTRemovableViewController.h			©2025 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTRemovableViewController
@interface AKTRemovableViewController : NSViewController

// MARK: Properties

@property (nonatomic, copy) 			void 		(^removeProc)(void);

@property (nonatomic, weak)	IBOutlet	NSButton*	removeButton;

// MARK: Instance methods

- (void) setRemoveButtonEnabled:(BOOL) enabled;

@end

NS_ASSUME_NONNULL_END
