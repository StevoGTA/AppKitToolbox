//----------------------------------------------------------------------------------------------------------------------
//	AKTTextCalendarDatePickerHelper+C++.mm			©2025 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTTextCalendarDatePickerHelper+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTextCalendarDatePickerHelper extension

@implementation AKTTextCalendarDatePickerHelper (Cpp)

// MARK: Property methods

//----------------------------------------------------------------------------------------------------------------------
- (SGregorianDate) gregorianDate
{
	// Setup
	NSDateComponents*	dateComponents =
								[[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]
										components:
												NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |
														NSCalendarUnitHour | NSCalendarUnitMinute |
														NSCalendarUnitSecond | NSCalendarUnitWeekday
										fromDate:self.dateValue];

	return SGregorianDate((UInt32) dateComponents.year, (UInt8) dateComponents.month, (UInt8) dateComponents.day,
			(UInt8) dateComponents.hour, (UInt8) dateComponents.minute, (Float32) dateComponents.second,
			(UInt8) dateComponents.weekday - 1);
}

//----------------------------------------------------------------------------------------------------------------------
- (void) setGregorianDate:(SGregorianDate) gregorianDate
{
	// Setup
	NSDateComponents*	dateComponents = [[NSDateComponents alloc] init];
	dateComponents.year = gregorianDate.getYear();
	dateComponents.month = gregorianDate.getMonth();
	dateComponents.day = gregorianDate.getDay();
	dateComponents.hour = gregorianDate.getHour();
	dateComponents.minute = gregorianDate.getMinute();
	dateComponents.second = gregorianDate.getSecond();

	// Set Date
	self.dateValue =
			[[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]
					dateFromComponents:dateComponents];
}

@end
