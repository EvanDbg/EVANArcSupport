#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <RemoteLog.h>

// fix arc main window
@interface SBFWindow : UIWindow
@end

@interface SBWindow : SBFWindow
@end

@interface SBMainScreenActiveInterfaceOrientationWindow : SBWindow
- (void)setContentViewController:(UIViewController *)arg1;
- (void)sb_setRootViewController:(id)arg1;
@end

%hook SBMainScreenActiveInterfaceOrientationWindow
%new
- (void)sb_setRootViewController:(id)arg1 {
	[self setContentViewController:arg1];
}
%end

// fix arc preferences => UIPickerView can not pull
@interface SCPAddButtonController
@end

@interface UIView (arcfix)
- (id)_viewControllerForAncestor;
@end

@interface UITableViewCellContentView : UIView
@end

%hook UITableViewCellContentView
- (void)layoutSubviews {
	%orig;
	id ancestorViewController = [self _viewControllerForAncestor];
	if ([ancestorViewController isKindOfClass:%c(SCPAddButtonController)]) {
		[self setHidden:YES];
	}
}
%end


// => this is not working at iOS14
// https://github.com/h4ckua11/ScreenRecording-Time/tree/f6c99b9415bf3fb654f41ef9dc133f700c497c7d
// https://github.com/gilshahar7/DNDMyRecording/
@interface RPControlCenterClient
- (void)callDelegate:(id)delegate;
- (void)initWithDelegate:(id)delegate;
@end

%hook RPControlCenterClient
%new
- (void)initWithDelegate:(id)delegate {
	// to stop the crash
  RLog(@"Arc Fix Log: %@", @">>>> RPControlCenterClient initWithDelegate");
}
%end

%ctor
{
    //Got this code from https://github.com/gilshahar7/DNDMyRecording/
    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.springboard"])
    {
        NSBundle* moduleBundle = [NSBundle bundleWithPath:@"/System/Library/ControlCenter/Bundles/ReplayKitModule.bundle"];
        if (!moduleBundle.loaded)
            [moduleBundle load];
    }
		%init;
}