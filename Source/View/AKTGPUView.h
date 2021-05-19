//----------------------------------------------------------------------------------------------------------------------
//	AKTGPUView.h			©2020 Stevo Brock		All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import "CGPU.h"
#import "TimeAndDate.h"

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTGPUView
@protocol AKTGPUView

// MARK: Properties
@property (nonatomic, readonly)	CGPU&	gpu;

@property (nonatomic, strong)	void	(^mouseDownProc)(NSEvent* event);
@property (nonatomic, strong)	void	(^mouseDraggedProc)(NSEvent* event);
@property (nonatomic, strong)	void	(^mouseUpProc)(NSEvent* event);

@property (nonatomic, strong)	void	(^periodicProc)(UniversalTimeInterval outputTime);

// MARK: Instance methods
- (void) installPeriodic;
- (void) removePeriodic;

@end

NS_ASSUME_NONNULL_END
