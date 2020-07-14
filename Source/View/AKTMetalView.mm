//----------------------------------------------------------------------------------------------------------------------
//	AKTMetalView.mm			©2020 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTMetalView.h"

#import "CMetalGPU.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: Local procs declaration

static	id<MTLDevice>				sGetDeviceProc(AKTMetalView* metalView);
static	id <CAMetalDrawable>		sGetCurrentDrawableProc(AKTMetalView* metalView);
static	MTLPixelFormat				sGetPixelFormatProc(AKTMetalView* metalView);
static	NSUInteger					sGetSampleCountProc(AKTMetalView* metalView);
static	MTLRenderPassDescriptor*	sGetCurrentRenderPassDescriptor(AKTMetalView* metalView);

//----------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
// MARK: - AKTMetalView

@interface AKTMetalView ()

@property (nonatomic, assign)	CGPU*	gpuInternal;

@end

@implementation AKTMetalView

@synthesize mouseDownProc;
@synthesize mouseDraggedProc;
@synthesize mouseUpProc;

@synthesize periodicProc;

// MARK: Lifecycle methods

//----------------------------------------------------------------------------------------------------------------------
- (instancetype) initWithFrame:(NSRect) frame
{
	// Setup
	id<MTLDevice>	device = MTLCreateSystemDefaultDevice();

	self = [super initWithFrame:frame device:device];
	if (self != nil) {
		// Complete setup
		self.delegate = self;

#if defined(DEBUG)
		self.clearColor = MTLClearColorMake(0.5, 0.0, 0.25, 1.0);
#endif

		self.gpuInternal =
				new CGPU(
						SGPUProcsInfo((CMetalGPUGetDeviceProc) sGetDeviceProc,
								(CMetalGPUGetCurrentDrawableProc) sGetCurrentDrawableProc,
								(CMetalGPUGetPixelFormatProc) sGetPixelFormatProc,
								(CMetalGPUGetSampleCountProc) sGetSampleCountProc,
								(CMetalGPUGetCurrentRenderPassDescriptor) sGetCurrentRenderPassDescriptor,
								(__bridge void*) self));
	}

	return self;
}

// MARK: NSResponder methods

//----------------------------------------------------------------------------------------------------------------------
- (void) mouseDown:(NSEvent*) event
{
	self.mouseDownProc(event);
}

//----------------------------------------------------------------------------------------------------------------------
- (void) mouseDragged:(NSEvent*) event
{
	self.mouseDraggedProc(event);
}

//----------------------------------------------------------------------------------------------------------------------
- (void) mouseUp:(NSEvent*) event
{
	self.mouseUpProc(event);
}

// MARK: AKTGPUView methods

//----------------------------------------------------------------------------------------------------------------------
- (CGPU&) gpu
{
	return *self.gpuInternal;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) installPeriodic
{
	self.paused = false;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) removePeriodic
{
	self.paused = true;
}

// MARK: MTKViewDelegate methods

//----------------------------------------------------------------------------------------------------------------------
- (void) mtkView:(nonnull MTKView*) view drawableSizeWillChange:(CGSize) size
{
}

//----------------------------------------------------------------------------------------------------------------------
- (void) drawInMTKView:(nonnull MTKView*) view
{
	// Run lean
	@autoreleasepool {
		// Call periodic proc
		self.periodicProc(
				SUniversalTime::getCurrentUniversalTime() +
						1.0 / (UniversalTimeInterval) self.preferredFramesPerSecond);
	}
}

@end

//----------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
// MARK: - Local proc definitions

//----------------------------------------------------------------------------------------------------------------------
id<MTLDevice> sGetDeviceProc(AKTMetalView* metalView)
{
	return metalView.device;
}

//----------------------------------------------------------------------------------------------------------------------
id <CAMetalDrawable> sGetCurrentDrawableProc(AKTMetalView* metalView)
{
	return metalView.currentDrawable;
}

//----------------------------------------------------------------------------------------------------------------------
MTLPixelFormat sGetPixelFormatProc(AKTMetalView* metalView)
{
	return metalView.colorPixelFormat;
}

//----------------------------------------------------------------------------------------------------------------------
NSUInteger sGetSampleCountProc(AKTMetalView* metalView)
{
	return metalView.sampleCount;
}

//----------------------------------------------------------------------------------------------------------------------
MTLRenderPassDescriptor* sGetCurrentRenderPassDescriptor(AKTMetalView* metalView)
{
	return metalView.currentRenderPassDescriptor;
}
