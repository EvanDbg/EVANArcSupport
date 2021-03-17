#import "EVANArcSupport.h"
#import <dlfcn.h>

@interface SBFWindow : UIWindow
@end

@interface SBWindow : SBFWindow
@end

@interface SBMainScreenActiveInterfaceOrientationWindow : SBWindow
-(void)setContentViewController:(UIViewController *)arg1 ;
-(void)sb_setRootViewController:(id)arg1 ;
@end

%hook SBMainScreenActiveInterfaceOrientationWindow
%new
- (void)sb_setRootViewController:(id)arg1 {
	[self setContentViewController:arg1];
}
%end

%ctor {
    dlopen(("/System/Library/PrivateFrameworks/SpringBoard.framework/SpringBoard"), RTLD_LAZY);
    %init;
}
