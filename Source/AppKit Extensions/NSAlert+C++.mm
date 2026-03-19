//----------------------------------------------------------------------------------------------------------------------
//	NSAlert+C++.mm			©2026 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "NSAlert+C++.h"

#import "Swift.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: NSAlert extension

@implementation NSAlert (Cpp)

// MARK: Class methods

//----------------------------------------------------------------------------------------------------------------------
+ (instancetype) informationalWithMessage:(NSString*) message error:(const SError&) error
		buttonTitle:(NSString*) buttonTitle
{
	return [NSAlert informationalWithMessage:message
			information:(__bridge NSString*) error.getLocalizedDescription().getOSString() buttonTitles:@[buttonTitle]];
}

//----------------------------------------------------------------------------------------------------------------------
+ (instancetype) warningWithMessage:(NSString*) message error:(const SError&) error
		buttonTitle:(NSString*) buttonTitle
{
	return [NSAlert warningWithMessage:message
			information:(__bridge NSString*) error.getLocalizedDescription().getOSString() buttonTitles:@[buttonTitle]];
}

//----------------------------------------------------------------------------------------------------------------------
+ (instancetype) criticalWithMessage:(NSString*) message error:(const SError&) error
		buttonTitle:(NSString*) buttonTitle
{
	return [NSAlert criticalWithMessage:message
			information:(__bridge NSString*) error.getLocalizedDescription().getOSString() buttonTitles:@[buttonTitle]];
}

@end
