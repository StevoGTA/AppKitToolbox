//----------------------------------------------------------------------------------------------------------------------
//	NSNib+Extensions.m			©2023 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "NSNib+Extensions.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSNib extension

@implementation NSNib (Extensions)

//----------------------------------------------------------------------------------------------------------------------
+ (nullable NSView*) instantiateViewWithClass:(Class) clas fromNibNamed:(NSString*) nibName bundle:(NSBundle*) bundle
{
	// Load NIB
	NSNib*	nib = [[NSNib alloc] initWithNibNamed:nibName bundle:bundle];

	// Get top level objects
	NSArray*	topLevelObjects;
	[nib instantiateWithOwner:nil topLevelObjects:&topLevelObjects];

	// Iterate top level objects
	for (NSUInteger i = 0; i < topLevelObjects.count; i++) {
		// Check this object
		if ([topLevelObjects[i] class] == clas)
			// Found it
			return topLevelObjects[i];
	}

	return nil;
}

//----------------------------------------------------------------------------------------------------------------------
+ (nullable NSView*) instantiateViewWithClass:(Class) clas fromNibNamed:(NSString*) nibName
{
	return [self instantiateViewWithClass:clas fromNibNamed:nibName bundle:NSBundle.mainBundle];
}

@end
