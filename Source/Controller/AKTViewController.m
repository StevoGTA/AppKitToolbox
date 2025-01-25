//----------------------------------------------------------------------------------------------------------------------
//	AKTViewController.m			©2025 Stevo Brock	All rights reserved.
//----------------------------------------------------------------------------------------------------------------------

#import "AKTViewController.h"

//----------------------------------------------------------------------------------------------------------------------
// MARK: AKTViewController

@interface AKTViewController ()

// MARK: Properties

@property (nonatomic, strong)	NSMutableArray<id <NSObject> >*	notificationObservers;

@end

@implementation AKTViewController

// MARK: Lifecycle methods

//----------------------------------------------------------------------------------------------------------------------
- (void) deinit
{
	for (id <NSObject> object in self.notificationObservers)
		// Remove observer
		[NSNotificationCenter.defaultCenter removeObserver:object];
}

// MARK: Instance methods

//----------------------------------------------------------------------------------------------------------------------
- (void) addNotificationObserverForName:(NSNotificationName) name object:(nullable id) object
		queue:(nullable NSOperationQueue*) queue proc:(void (^)(NSNotification* notification)) proc
{
	// Setup
	if (!self.notificationObservers)
		// Create
		self.notificationObservers = [[NSMutableArray alloc] init];

	// Add
	[self.notificationObservers
			addObject:
					[NSNotificationCenter.defaultCenter addObserverForName:name object:object queue:queue
							usingBlock:proc]];
}

//----------------------------------------------------------------------------------------------------------------------
- (void) addNotificationObserverForName:(NSNotificationName) name object:(nullable id) object
		proc:(void (^)(NSNotification* notification)) proc
{
	[self addNotificationObserverForName:name object:object queue:nil proc:proc];
}

@end
