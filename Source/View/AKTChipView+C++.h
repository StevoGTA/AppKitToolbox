//----------------------------------------------------------------------------------------------------------------------
//	AKTChipView+C++.h			©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "SChipInfo.h"

#import <AppKit/AppKit.h>

#import "Swift.h"

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTChipView extension

@interface AKTChipView (Cpp)

// MARK: Class methods

+ (AKTChipViewInfo*) infoFor:(const SChipInfo&) chipInfo;

// MARK: Instance methods

- (void) setCppInfo:(const SChipInfo&) chipInfo;

@end

NS_ASSUME_NONNULL_END
