#import <RemoteLog.h>
#import <ReplayKit/ReplayKit.h>
#import <substrate.h>
#import <objc/runtime.h>
#import <objc/message.h>

@interface SCPMenuButton : UIView
@end

@interface SCPRecordButton : SCPMenuButton
@end

@interface RPScreenRecorder (iOS14)
- (void)startSystemRecordingWithMicrophoneEnabled:(BOOL)arg1 handler:(id)arg2;
- (void)stopSystemRecording:(id)arg1;
@end

// fix arc crash on record button
%hook SCPRecordButton
- (id)initWithFrame:(CGRect)rect {
  // SCPRecordButton *v15 = self;
  // SCPRecordButton *v3 = (SCPRecordButton *)objc_msgSendSuper2(
  //                           &v15,
  //                           "initWithFrame:",
  //                           arg1.origin.x,
  //                           arg1.origin.y,
  //                           arg1.size.width,
  //                           arg1.size.height,
  //                           self,
  //                           &OBJC_CLASS___SCPRecordButton);
  objc_super $super = {self, objc_getClass("SCPMenuButton")};
  return objc_msgSendSuper(&$super, @selector(initWithFrame:), rect);
  // return self;
}

- (void)performAction {
  // Please wait until i find the way to start and stop Screen Record
  RPScreenRecorder* recorder = [RPScreenRecorder sharedRecorder];
  if ([recorder isRecording]) {
    [recorder stopSystemRecording:nil];
  } else {
    [recorder startSystemRecordingWithMicrophoneEnabled:NO handler:^(NSError * _Nullable error) {
    }];
  }
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

%hook SCPMenuViewController
- (void)traitCollectionDidChange:(id)arg1 {
  
}
%end
