//----------------------------------------------------------------------------------------------------------------------
//	AKTVideoFrameView.h			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "CVideoFrame.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTVideoFrameView
@interface AKTVideoFrameView : NSView

// MARK: Instance methods

- (void) setVideoFrame:(const CVideoFrame&) videoFrame;

@end

NS_ASSUME_NONNULL_END
