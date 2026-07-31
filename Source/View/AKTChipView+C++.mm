//----------------------------------------------------------------------------------------------------------------------
//	AKTChipView+C++.mm			©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTChipView+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTChipView extension

@implementation AKTChipView (Cpp)

// MARK: Class methods

//----------------------------------------------------------------------------------------------------------------------
+ (AKTChipViewInfo*) infoFor:(const SChipInfo&) chipInfo
{
	// Compose Info
	return [[AKTChipViewInfo alloc]
			initWithText:(__bridge NSString*) chipInfo.getText().getOSString()
			style:
					(chipInfo.getStyle() == SChipInfo::kStyleFilled) ?
							AKTChipViewInfoStyleFilled : AKTChipViewInfoStyleOutlined
			symbol:
					(chipInfo.getSymbol() == SChipInfo::kSymbolLocked) ?
							AKTChipViewInfoSymbolLocked : AKTChipViewInfoSymbolNone];
}

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (void) setCppInfo:(const SChipInfo&) chipInfo
{
	// Set
	self.info = [AKTChipView infoFor:chipInfo];
}

@end
