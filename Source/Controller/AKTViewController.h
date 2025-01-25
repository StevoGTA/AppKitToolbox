//----------------------------------------------------------------------------------------------------------------------
//	AKTViewController.h			©2025 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#pragma once

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTViewController
@interface AKTViewController : NSViewController

// MARK: Instance methods

- (void) addNotificationObserverForName:(NSNotificationName) name object:(nullable id) object
		queue:(nullable NSOperationQueue*) queue proc:(void (^)(NSNotification* notification)) proc;
- (void) addNotificationObserverForName:(NSNotificationName) name object:(nullable id) object
		proc:(void (^)(NSNotification* notification)) proc;

@end

NS_ASSUME_NONNULL_END
