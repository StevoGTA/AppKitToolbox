//----------------------------------------------------------------------------------------------------------------------
//	AKTOpenGLView.mm			©2019 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTOpenGLView.h"

#import "CLogServices.h"
#import "COpenGLGPU.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: Local procs declaration

static	void				sAcquireContext(AKTOpenGLView* openGLView);
static	bool				sTryAcquireContext(AKTOpenGLView* openGLView);
static	void				sReleaseContext(AKTOpenGLView* openGLView);
static	S2DSizeU16			sGetSize(AKTOpenGLView* openGLView);
static	Float32				sGetScale(AKTOpenGLView* openGLView);
static	CGLContextObj		sGetContext(AKTOpenGLView* openGLView);
static	CGLPixelFormatObj	sGetPixelFormat(AKTOpenGLView* openGLView);
static	CVReturn			sDisplayLinkOutput(CVDisplayLinkRef displayLink, const CVTimeStamp* inNow,
									const CVTimeStamp* inOutputTime, CVOptionFlags flagsIn, CVOptionFlags* flagsOut,
									void* context);

//----------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
// MARK: - AKTOpenGLView

@interface AKTOpenGLView ()

@property (nonatomic, assign)	CGPU*				gpuInternal;
@property (nonatomic, assign)	CGSize				size;
@property (nonatomic, assign)	CGFloat				contentsScale;

@property (nonatomic, strong)	NSLock*				contextLock;

@property (nonatomic, assign)	CVDisplayLinkRef	displayLinkRef;
@property (nonatomic, strong)	NSLock*				displayLinkLock;

@end

@implementation AKTOpenGLView

@synthesize mouseDownProc;
@synthesize mouseDraggedProc;
@synthesize mouseUpProc;

@synthesize periodicProc;

// MARK: Lifecycle methods

//----------------------------------------------------------------------------------------------------------------------
- (instancetype) initWithFrame:(NSRect) frame
{
	// Setup pixel format
	NSOpenGLPixelFormatAttribute pixelFormatAttributes[] = {
																NSOpenGLPFAOpenGLProfile, NSOpenGLProfileVersion3_2Core,
																NSOpenGLPFADoubleBuffer,
																NSOpenGLPFADepthSize, 16,
																0,
														   };
	NSOpenGLPixelFormat*	pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:pixelFormatAttributes];

	self = [super initWithFrame:frame pixelFormat:pixelFormat];
	if (self != nil) {
		// Complete setup
		self.wantsBestResolutionOpenGLSurface = YES;

		self.openGLContext = [[NSOpenGLContext alloc] initWithFormat:pixelFormat shareContext:nil];
//		CGLEnable(self.openGLContext.CGLContextObj, kCGLCECrashOnRemovedFunctions);

		self.contextLock = [[NSLock alloc] init];
		self.displayLinkLock = [[NSLock alloc] init];

		self.gpuInternal =
				new CGPU(
						CGPU::Procs((CGPU::Procs::AcquireContextProc) sAcquireContext,
								(CGPU::Procs::TryAcquireContextProc) sTryAcquireContext,
								(CGPU::Procs::ReleaseContextProc) sReleaseContext,
								(CGPU::Procs::GetSizeProc) sGetSize, (CGPU::Procs::GetScaleProc) sGetScale,
								(CGPU::Procs::GetContextProc) sGetContext,
								(CGPU::Procs::GetPixelFormatProc) sGetPixelFormat, (__bridge void*) self));
	}

	return self;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) deinit
{
	// Cleanup
	[self removePeriodic];

	Delete(self.gpuInternal);
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

// MARK: NSView methods

//----------------------------------------------------------------------------------------------------------------------
- (void) setFrameSize:(NSSize) newSize
{
	// Do super
	[super setFrameSize:newSize];

	// Store
	self.size = self.bounds.size;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) renewGState
{
	// Called whenever graphics state has been updated (such as window resize).  OpenGL rendering is not synchronous
	//	with other rendering on macOS.  Therefore, call disableScreenUpdatesUntilFlush so the window server doesn't
	//	render non-OpenGL content in the window asynchronously from OpenGL content, which could cause flickering.
	//	(non-OpenGL content includes the title bar and drawing done by the app with other APIs)
	[self.window disableScreenUpdatesUntilFlush];

	// Do super
	[super renewGState];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) viewDidChangeBackingProperties
{
	// Do super
	[super viewDidChangeBackingProperties];

	// Get current info
	self.contentsScale = self.window.backingScaleFactor;
}

// MARK: NSOpenGLView methods

//----------------------------------------------------------------------------------------------------------------------
- (void) prepareOpenGL
{
	// Do super
	[super prepareOpenGL];

	// Setup context
	[self.openGLContext makeCurrentContext];

	// Synchronize buffer swaps with vertical refresh rate
	GLint	swapInt = 1;
	[self.openGLContext setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
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
	// Check display link ref
	if (self.displayLinkRef == nil) {
		// Create
		CVDisplayLinkRef	displayLinkRef;
		CVReturn			error;
		error = ::CVDisplayLinkCreateWithActiveCGDisplays(&displayLinkRef);
		if (error != kCVReturnSuccess) {
			CLogServices::logError(
					CString(OSSTR("CVDisplayLinkCreateWithActiveCGDisplays() returned error ")) + CString(error));

			return;
		}

		// Store
		self.displayLinkRef = displayLinkRef;

		// Set output callback
		error = ::CVDisplayLinkSetOutputCallback(self.displayLinkRef, sDisplayLinkOutput, (__bridge void*) self);
		if (error != kCVReturnSuccess) {
			CLogServices::logError(CString(OSSTR("CVDisplayLinkSetOutputCallback() returned error ")) + CString(error));

			return;
		}

		// Set current CGDisplay from OpenGL context
		error =
				::CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(self.displayLinkRef,
						self.openGLContext.CGLContextObj, self.pixelFormat.CGLPixelFormatObj);
		if (error != kCVReturnSuccess) {
			CLogServices::logError(
					CString(OSSTR("CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext() returned error ")) +
							CString(error));

			return;
		}

		// Start
		error = ::CVDisplayLinkStart(self.displayLinkRef);
		if (error != kCVReturnSuccess) {
			CLogServices::logError(CString(OSSTR("CVDisplayLinkStart() returned error ")) + CString(error));

			return;
		}
	}
}

//----------------------------------------------------------------------------------------------------------------------
- (void) removePeriodic
{
	// Lock to make sure we are not removing while in output callback
	[self.displayLinkLock lock];
	::CVDisplayLinkStop(self.displayLinkRef);
	::CVDisplayLinkRelease(self.displayLinkRef);
	[self.displayLinkLock unlock];

	// Clear
	self.displayLinkRef = nil;
}

// MARK: Internal methods

//----------------------------------------------------------------------------------------------------------------------
- (void) acquireContext
{
	// Lock
	[self.contextLock lock];

	// Make current
	[self.openGLContext makeCurrentContext];
}

//----------------------------------------------------------------------------------------------------------------------
- (BOOL) tryAcquireContext
{
	// Try lock
	if ([self.contextLock tryLock]) {
		// Make current
		[self.openGLContext makeCurrentContext];

		return YES;
	} else
		// Failed
		return NO;
}

//----------------------------------------------------------------------------------------------------------------------
- (void) releaseContext
{
	// Release lock
	[self.contextLock unlock];
}

@end

//----------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
// MARK: - Local proc definitions

//----------------------------------------------------------------------------------------------------------------------
void sAcquireContext(AKTOpenGLView* openGLView)
{
	[openGLView acquireContext];
}

//----------------------------------------------------------------------------------------------------------------------
bool sTryAcquireContext(AKTOpenGLView* openGLView)
{
	return [openGLView tryAcquireContext];
}

//----------------------------------------------------------------------------------------------------------------------
void sReleaseContext(AKTOpenGLView* openGLView)
{
	[openGLView releaseContext];
}

//----------------------------------------------------------------------------------------------------------------------
S2DSizeU16 sGetSize(AKTOpenGLView* openGLView)
{
	return S2DSizeU16(openGLView.size.width, openGLView.size.height);
}

//----------------------------------------------------------------------------------------------------------------------
Float32 sGetScale(AKTOpenGLView* openGLView)
{
	return openGLView.contentsScale;
}

//----------------------------------------------------------------------------------------------------------------------
CGLContextObj sGetContext(AKTOpenGLView* openGLView)
{
	return openGLView.openGLContext.CGLContextObj;
}

//----------------------------------------------------------------------------------------------------------------------
CGLPixelFormatObj sGetPixelFormat(AKTOpenGLView* openGLView)
{
	return openGLView.openGLContext.pixelFormat.CGLPixelFormatObj;
}

//----------------------------------------------------------------------------------------------------------------------
CVReturn sDisplayLinkOutput(CVDisplayLinkRef displayLink, const CVTimeStamp* inNow, const CVTimeStamp* inOutputTime,
		CVOptionFlags flagsIn, CVOptionFlags* flagsOut, void* context)
{
	// Setup
	AKTOpenGLView*	openGLView = (__bridge AKTOpenGLView*) context;

	// Try to acquire lock
	if ([openGLView.displayLinkLock tryLock]) {
		@autoreleasepool {
			// Lock context
			::CGLLockContext(openGLView.openGLContext.CGLContextObj);

			// Call proc
			openGLView.periodicProc(
					(UniversalTimeInterval) inOutputTime->videoTime /
							(UniversalTimeInterval) inOutputTime->videoTimeScale);

			// Flush
			::CGLFlushDrawable(openGLView.openGLContext.CGLContextObj);

			// Unlock context
			::CGLUnlockContext(openGLView.openGLContext.CGLContextObj);
		}

		// All done
		[openGLView.displayLinkLock unlock];
	}

	return kCVReturnSuccess;
}
