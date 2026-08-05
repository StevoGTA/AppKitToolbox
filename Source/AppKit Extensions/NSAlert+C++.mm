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
+ (instancetype) informationalWithMessage:(const CString&) message accessoryView:(NSView*) accessoryView
		confirmButtonTitle:(const CString&) confirmButtonTitle cancelButtonTitle:(const CString&) cancelButtonTitle
{
	// Create
	NSAlert*	alert =
						[NSAlert informationalWithMessage:(__bridge NSString*) message.getOSString() information:@""
								buttonTitles:
										@[
											(__bridge NSString*) confirmButtonTitle.getOSString(),
											(__bridge NSString*) cancelButtonTitle.getOSString(),
										]];
	alert.accessoryView = accessoryView;

	return alert;
}

//----------------------------------------------------------------------------------------------------------------------
+ (instancetype) warningWithMessage:(NSString*) message error:(const SError&) error
		buttonTitle:(NSString*) buttonTitle
{
	return [NSAlert warningWithMessage:message
			information:(__bridge NSString*) error.getLocalizedDescription().getOSString() buttonTitles:@[buttonTitle]];
}

//----------------------------------------------------------------------------------------------------------------------
+ (instancetype) warningWithMessageString:(const CString&) messageString error:(const SError&) error
		buttonTitleString:(const CString&) buttonTitleString
{
	return [NSAlert warningWithMessage:(__bridge NSString*) messageString.getOSString() error:error
			buttonTitle:(__bridge NSString*) buttonTitleString.getOSString()];
}

//----------------------------------------------------------------------------------------------------------------------
+ (instancetype) warningWithMessage:(const CString&) message confirmButtonTitle:(const CString&) confirmButtonTitle
		cancelButtonTitle:(const CString&) cancelButtonTitle
{
	return [NSAlert warningWithMessage:(__bridge NSString*) message.getOSString() information:@""
			buttonTitles:
					@[
						(__bridge NSString*) confirmButtonTitle.getOSString(),
						(__bridge NSString*) cancelButtonTitle.getOSString(),
					]];
}

//----------------------------------------------------------------------------------------------------------------------
+ (instancetype) criticalWithMessage:(NSString*) message error:(const SError&) error
		buttonTitle:(NSString*) buttonTitle
{
	return [NSAlert criticalWithMessage:message
			information:(__bridge NSString*) error.getLocalizedDescription().getOSString() buttonTitles:@[buttonTitle]];
}

@end
