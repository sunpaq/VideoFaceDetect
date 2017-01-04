#ifndef AVCamVideoCaptureDelegate_h
#define AVCamVideoCaptureDelegate_h

#import <AVFoundation/AVFoundation.h>
#import "AVCamCameraViewController.h"

@interface AVCamVideoCaptureDelegate : NSObject<AVCaptureFileOutputRecordingDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (weak, nonatomic) AVCamCameraViewController* camviewController;

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithCameraViewController:(AVCamCameraViewController*)cvc;

@end

#endif /* AVCamVideoCaptureDelegate_h */
