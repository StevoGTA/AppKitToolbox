//----------------------------------------------------------------------------------------------------------------------
//	AKTWindow.h			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTWindow

@interface AKTWindow : NSWindow

// MARK: Class methods

// MARK: Instance methods
- (void) addKeyboardInputHandler:(NSResponder*) keyboardInputHandler;

@end

NS_ASSUME_NONNULL_END
