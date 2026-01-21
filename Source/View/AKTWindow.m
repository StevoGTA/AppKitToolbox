//----------------------------------------------------------------------------------------------------------------------
//	AKTWindow.m			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTWindow.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTWindowKeyboardHandler

@interface AKTWindowKeyboardHandler : NSObject

@property (nonatomic, copy)	BOOL	(^keyDownProc)(NSEvent* event);
@property (nonatomic, copy)	BOOL	(^keyUpProc)(NSEvent* event);

@end

@implementation AKTWindowKeyboardHandler

//----------------------------------------------------------------------------------------------------------------------
+ (instancetype) keyboardHandlerWithKeyDownProc:(BOOL (^)(NSEvent* event)) keyDownProc
		keyUpProc:(BOOL (^)(NSEvent* event)) keyUpProc
{
	// Setup
	AKTWindowKeyboardHandler*	keyboardHandler = [[AKTWindowKeyboardHandler alloc] init];
	keyboardHandler.keyDownProc = keyDownProc;
	keyboardHandler.keyUpProc = keyUpProc;

	return keyboardHandler;
}

@end

//----------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
// MARK: - AKTWindow

@interface AKTWindow ()

@property (nonatomic, strong)	NSMutableArray<AKTWindowKeyboardHandler*>*	keyboardHandlers;

@end

@implementation AKTWindow

// MARK: NSResponder methods

//----------------------------------------------------------------------------------------------------------------------
- (void) keyDown:(NSEvent*) event
//----------------------------------------------------------------------------------------------------------------------
{
	// Check keyboard handlers
	for (AKTWindowKeyboardHandler* keyboardHandler in self.keyboardHandlers) {
		// Call handler
		if (keyboardHandler.keyDownProc(event))
			// Handled
			return;
	}

	// Do super
	[super keyDown:event];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) keyUp:(NSEvent*) event
//----------------------------------------------------------------------------------------------------------------------
{
	// Check keyboard handlers
	for (AKTWindowKeyboardHandler* keyboardHandler in self.keyboardHandlers) {
		// Call handler
		if (keyboardHandler.keyUpProc(event))
			// Handled
			return;
	}

	// Do super
	[super keyUp:event];
}

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (void) addKeyboardInputHandlerWithKeyDownProc:(BOOL (^)(NSEvent* event)) keyDownProc
		keyUpProc:(BOOL (^)(NSEvent* event)) keyUpProc
//----------------------------------------------------------------------------------------------------------------------
{
	// Setup
	if (self.keyboardHandlers == nil)
		// Create
		self.keyboardHandlers = [[NSMutableArray alloc] init];
		
	// Add keyboard handler
	[self.keyboardHandlers
			addObject:[AKTWindowKeyboardHandler keyboardHandlerWithKeyDownProc:keyDownProc keyUpProc:keyUpProc]];
}

@end
