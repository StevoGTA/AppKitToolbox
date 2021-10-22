//----------------------------------------------------------------------------------------------------------------------
//	AKTVideoFrameView.mm			©2021 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTVideoFrameView.h"

#import <VideoToolbox/VideoToolbox.h>

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTVideoFrameView

@implementation AKTVideoFrameView

// MARK: Lifecycle methods

//----------------------------------------------------------------------------------------------------------------------
- (instancetype) initWithFrame:(NSRect) frame
{
	// Do super
	self = [super initWithFrame:frame];
	if (self != nil) {
		// Setup
		self.wantsLayer = YES;
		self.layer.backgroundColor = NSColor.blackColor.CGColor;
		self.layer.contentsGravity = kCAGravityResizeAspect;
	}

	return self;
}

//----------------------------------------------------------------------------------------------------------------------
- (instancetype) initWithCoder:(NSCoder*) coder
{
	// Do super
	self = [super initWithCoder:coder];
	if (self != nil) {
		// Setup
		self.wantsLayer = YES;
		self.layer.backgroundColor = NSColor.blackColor.CGColor;
		self.layer.contentsGravity = kCAGravityResizeAspect;
	}

	return self;
}

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (void) setVideoFrame:(const CVideoFrame&) videoFrame
{
	// Compose CGImageRef
	CGImageRef	imageRef;
	OSStatus	status = VTCreateCGImageFromCVPixelBuffer(videoFrame.getImageBufferRef(), nil, &imageRef);
	if (status == noErr) {
		// Success
		__weak	typeof(self)	weakSelf = self;
		dispatch_async(dispatch_get_main_queue(), ^{ weakSelf.layer.contents = (__bridge id) imageRef; });
	}
}

@end
