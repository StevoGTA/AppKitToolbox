//----------------------------------------------------------------------------------------------------------------------
//	NSColor+C++.mm			©2023 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "NSColor+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSColor extension

@implementation NSColor (Cpp)

// MARK: Property methods

//----------------------------------------------------------------------------------------------------------------------
- (CColor) cColor
{
	// Setup
	NSColor*	color = [self colorUsingColorSpace:NSColorSpace.sRGBColorSpace];

	return CColor(CColor::kTypeRGB, (Float32) color.redComponent, color.greenComponent, color.blueComponent,
			color.alphaComponent);
}

// MARK: Class methods

//----------------------------------------------------------------------------------------------------------------------
+ (NSColor*) colorForCColor:(const CColor&) color
{
	return [NSColor colorWithRed:color.getRed() green:color.getGreen() blue:color.getBlue() alpha:color.getAlpha()];
}

@end
