//----------------------------------------------------------------------------------------------------------------------
//	NSTextField+C++.mm			©2021 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "NSTextField+C++.h"

#import "NSString+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSTextField extension

@implementation NSTextField (Cpp)

// MARK: Properties

//----------------------------------------------------------------------------------------------------------------------
- (CString) string
{
	return CString((__bridge CFStringRef) self.stringValue);
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setString:(CString) string
{
	self.stringValue = [(__bridge NSString*) string.getOSString() copy];
}

//----------------------------------------------------------------------------------------------------------------------
- (OV<CString>) ovString
{
	return  (self.stringValue.length > 0) ? OV<CString>(self.string) : OV<CString>();
}

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (void) setString:(const CString&) string animated:(BOOL) animated
{
	// Check animated
	if (animated)
		// Animated
		self.animator.stringValue = [(__bridge NSString*) string.getOSString() copy];
	else
		// Update
		self.stringValue = [(__bridge NSString*) string.getOSString() copy];
}

// MARK: Class methods

//----------------------------------------------------------------------------------------------------------------------
+ (instancetype) createWithString:(const CString&) string
{
	return [[NSTextField alloc] initWithString:string];
}

//----------------------------------------------------------------------------------------------------------------------
+ (instancetype) createWithString:(const CString&) string controlSize:(NSControlSize) controlSize
{
	return [[NSTextField alloc] initWithString:string controlSize:controlSize];
}

// MARK: Lifecycle methods

//----------------------------------------------------------------------------------------------------------------------
- (instancetype) initWithString:(const CString&) string
{
	// Do super
	self = [super initWithFrame:NSZeroRect];
	if (self) {
		// Setup
		self.bordered = NO;
		self.drawsBackground = NO;
		self.editable = NO;
		self.stringValue = [(__bridge NSString*) string.getOSString() copy];
	}

	return self;
}

//----------------------------------------------------------------------------------------------------------------------
- (instancetype) initWithString:(const CString&) string controlSize:(NSControlSize) controlSize
{
	// Do super
	self = [super initWithFrame:NSZeroRect];
	if (self) {
		// Setup
		self.bordered = NO;
		self.drawsBackground = NO;
		self.editable = NO;
		self.stringValue = [(__bridge NSString*) string.getOSString() copy];
		self.controlSize = controlSize;
	}

	return self;
}

@end
