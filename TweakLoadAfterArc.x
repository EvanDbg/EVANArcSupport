#import <RemoteLog.h>
#import <libactivator/libactivator.h>

#define LASendEventWithName(eventName) \
	[LASharedActivator sendEventToListener:[LAEvent eventWithName:eventName mode:[LASharedActivator currentEventMode]]]

static NSString *Arc = @"Arc Event";

@interface SCPRecordButton
@end

@interface SCPAppButton
@property (nonatomic, strong, readwrite) NSString *bundleID;
@end

// fix arc crash on record button
%hook SCPRecordButton
- (void)performAction {
  // Please wait until i find the way to start and stop Screen Record
  RLog(@"Arc Fix Log: %@", @">>>> SCPRecordButton performAction");
}
%end

// fix arc take screen shot too fast
%hook SCPSSButton
- (void)performAction {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    %orig();
  });   
}
%end

// add a function that, when you set activator app to open.
// it will send an activator event
%hook SCPAppButton
- (void)performAction {
	if ([self.bundleID isEqualToString:@"libactivator"]) {
    RLog(@"Arc Fix Log: %@", @">>>> LASendEventWithName(Arc)");
		LASendEventWithName(Arc);
	} else {
		%orig;
	}
}
%end

@interface ControlCenterDataSource : NSObject <LAEventDataSource>
+ (id)sharedInstance;
@end

@implementation ControlCenterDataSource
+ (id)sharedInstance {
	static id sharedInstance = nil;
	static dispatch_once_t token = 0;
	dispatch_once(&token, ^{
		sharedInstance = [self new];
	});
	return sharedInstance;
}
+ (void)load {
	[self sharedInstance];
}
- (id)init {
	if (self = [super init]) {
		[LASharedActivator registerEventDataSource:self forEventName:Arc];
	}
	return self;
}
- (NSString *)localizedTitleForEventName:(NSString *)eventName {
	if ([eventName isEqualToString:Arc]) {
		return @"Arc Event";
	}
	return @" ";
}
- (NSString *)localizedGroupForEventName:(NSString *)eventName {
	return @"Arc";
}
- (NSString *)localizedDescriptionForEventName:(NSString *)eventName {
	if ([eventName isEqualToString:Arc]) {
		return @"Triggered when Arc select Activator Application";
	}
	return @" ";
}
- (void)dealloc {
	[LASharedActivator unregisterEventDataSourceWithEventName:Arc];
	// [super dealloc];
}
@end