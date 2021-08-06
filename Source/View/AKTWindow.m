//----------------------------------------------------------------------------------------------------------------------
//	AKTWindow.m			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTWindow.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTWindow

@interface AKTWindow ()

@property (nonatomic, weak)		NSResponder*	keyboardInputHandlerFirstResponder;

@end

@implementation AKTWindow

// MARK: NSResponder methods

//----------------------------------------------------------------------------------------------------------------------
- (void) keyDown:(NSEvent*) event
//----------------------------------------------------------------------------------------------------------------------
{
	// Check if have keyboard input handler first responder
	if (self.keyboardInputHandlerFirstResponder != nil)
		// Have
		[self.keyboardInputHandlerFirstResponder keyDown:event];
	else
		// Have not
		[super keyDown:event];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) keyUp:(NSEvent*) event
//----------------------------------------------------------------------------------------------------------------------
{
	// Check if have keyboard input handler first responder
	if (self.keyboardInputHandlerFirstResponder != nil)
		// Have
		[self.keyboardInputHandlerFirstResponder keyUp:event];
	else
		// Have not
		[super keyUp:event];
}

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (void) addKeyboardInputHandler:(NSResponder*) keyboardInputHandler
//----------------------------------------------------------------------------------------------------------------------
{
	// Setup
	keyboardInputHandler.nextResponder = self.keyboardInputHandlerFirstResponder;
	self.keyboardInputHandlerFirstResponder = keyboardInputHandler;
}

@end
