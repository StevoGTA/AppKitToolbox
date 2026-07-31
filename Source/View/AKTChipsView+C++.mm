//----------------------------------------------------------------------------------------------------------------------
//	AKTChipsView+C++.mm			©2026 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTChipsView+C++.h"

#import "AKTChipView+C++.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTChipsView extension

@implementation AKTChipsView (Cpp)

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (void) setCppChipInfos:(const TArray<SChipInfo>&) chipInfos
{
	// Compose Infos
	NSMutableArray<AKTChipViewInfo*>*	infos = [[NSMutableArray alloc] init];
	for (TArray<SChipInfo>::Iterator iterator = chipInfos.getIterator(); iterator; iterator++)
		// Add Info
		[infos addObject:[AKTChipView infoFor:*iterator]];

	// Set
	self.infos = infos;
}

@end
