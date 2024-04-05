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

	return CColor(CColor::RGBValues((Float32) color.redComponent, color.greenComponent, color.blueComponent,
			color.alphaComponent));
}

// MARK: Class methods

//----------------------------------------------------------------------------------------------------------------------
+ (NSColor*) colorForCColor:(const CColor&) color
{
	// Setup
	CColor::RGBValues	rgbValues = color.getRGBValues();

	return [NSColor colorWithRed:rgbValues.getRed() green:rgbValues.getGreen() blue:rgbValues.getBlue()
			alpha:rgbValues.getAlpha()];
}

@end
