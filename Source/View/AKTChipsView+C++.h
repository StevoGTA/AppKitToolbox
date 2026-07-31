//----------------------------------------------------------------------------------------------------------------------
//	AKTChipsView+C++.h			©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "SChipInfo.h"

#import <AppKit/AppKit.h>

#import "Swift.h"

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTChipsView extension

@interface AKTChipsView (Cpp)

// MARK: Instance methods

- (void) setCppChipInfos:(const TArray<SChipInfo>&) chipInfos;

@end

NS_ASSUME_NONNULL_END
