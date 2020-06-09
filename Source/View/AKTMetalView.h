//----------------------------------------------------------------------------------------------------------------------
//	AKTMetalView.h			©2020 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "AKTGPUView.h"

#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTMetalView

@interface AKTMetalView : MTKView <AKTGPUView, MTKViewDelegate>

// MARK: Lifecycle methods
- (instancetype) initWithFrame:(NSRect) frame;

@end

NS_ASSUME_NONNULL_END
