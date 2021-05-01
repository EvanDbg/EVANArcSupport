#import <RemoteLog.h>
#import <ReplayKit/ReplayKit.h>

@interface SCPRecordButton
@end

@interface RPScreenRecorder (iOS14)
- (void)startSystemRecordingWithMicrophoneEnabled:(BOOL)arg1 handler:(id)arg2;
- (void)stopSystemRecording:(id)arg1;
@end

// fix arc crash on record button
%hook SCPRecordButton
- (void)performAction {
  // Please wait until i find the way to start and stop Screen Record
  RLog(@"Arc Fix Log: %@", @">>>> SCPRecordButton performAction");
  RPScreenRecorder* recorder = [RPScreenRecorder sharedRecorder];
  if ([recorder isRecording]) {
    RLog(@"Arc Fix Log: %@", @">>>> RPScreenRecorder isRecording is YES");
    [recorder stopSystemRecording:nil];
  } else {
    RLog(@"Arc Fix Log: %@", @">>>> RPScreenRecorder isRecording is NO");
    [recorder startSystemRecordingWithMicrophoneEnabled:NO handler:^(NSError * _Nullable error) {
      RLog(@"Arc Fix Log: %@", [error localizedDescription]);
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

