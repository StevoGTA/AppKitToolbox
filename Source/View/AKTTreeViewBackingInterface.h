//----------------------------------------------------------------------------------------------------------------------
//	AKTTreeViewBackingInterface.h			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTTreeViewBackingInterface

@protocol AKTTreeViewBackingInterface <NSObject>

// MARK: Properties

@property (nonatomic, readonly)	NSString*	rootItemID;

// MARK: Instance methods

- (BOOL) hasChildrenOfItemID:(NSString*) itemID;
- (NSInteger) childCountOfItemID:(NSString*) itemID;
- (NSString*) childItemIDOfItemID:(NSString*) itemID atIndex:(NSInteger) index;

@end

NS_ASSUME_NONNULL_END
