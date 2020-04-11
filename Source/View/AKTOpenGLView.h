//----------------------------------------------------------------------------------------------------------------------
//	AKTOpenGLView.h			©2020 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "AKTGPUView.h"
#import "CGPU.h"
#import "TimeAndDate.h"

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTOpenGLView

@interface AKTOpenGLView : NSOpenGLView <AKTGPUView>

// MARK: Lifecycle methods
- (instancetype) initWithFrame:(NSRect) frame;

@end

NS_ASSUME_NONNULL_END
